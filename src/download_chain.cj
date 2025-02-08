/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights resvered.
 */

package download4cj

public class DownloadChain {

    let m:MultiConditionMonitor = MultiConditionMonitor()
    private static let TAG:String = "DownloadChain"
    private let blockIndex:Int64

    private let task:DownloadTask
    private let info:BreakpointInfo
    private let cache:DownloadCache

    let connectInterceptorList:ArrayList<InterceptorConnect> = ArrayList<InterceptorConnect>()
    let fetchInterceptorList:ArrayList<InterceptorFetch> = ArrayList<InterceptorFetch>()

    var connectIndex:Int64 = 0
    var fetchIndex:Int64 = 0

    private var responseContentLength:Int64 = 0
    private var connection:Option<DownloadConnection>

    var noCallbackIncreaseBytes:Int64
    private let callbackDispatcher:CallbackDispatcher

    private let store:DownloadStore

    let finished:AtomicBool = AtomicBool(false)


    static func createChain(blockIndex:Int64,task:DownloadTask,info:BreakpointInfo,cache:DownloadCache,store:DownloadStore):DownloadChain{
         return DownloadChain(blockIndex, task, info, cache, store)
    }

    private init(blockIndex:Int64,task:DownloadTask,info:BreakpointInfo,cache:DownloadCache,store:DownloadStore){
        this.blockIndex = blockIndex
        this.task = task
        this.cache = cache
        this.info = info
        this.store = store
        this.callbackDispatcher = Download4cj.withs().callbackDispatcher()
        this.connection = Option<DownloadConnection>.None
        this.noCallbackIncreaseBytes = 0
    }

    func getResponseContentLength():Int64{
        return responseContentLength
    }

    func setResponseContentLength(responseContentLength:Int64):Unit{
        this.responseContentLength = responseContentLength
    }

    func cancel():Unit{
        if (finished.load()){
            return
        }
        //java这边有个线程interrupt，仓颉则没有
    }

    func getTask():DownloadTask{
        return task
    }

    func getInfo():BreakpointInfo{
        return this.info
    }

    func getBlockIndex():Int64{
        return blockIndex
    }

    func getCache():DownloadCache{
        return cache
    }

    func getOutputStream():MultiPointOutputStream{
        return  this.cache.getOutputStream()
    }

    func getConnectionOrCreate():DownloadConnection{
        synchronized(m){

            if (cache.isInterrupt()){
                throw InterruptException.SIGNAL
            }
            if(let Some(_) <- connection){
            }else{
                var url:String = ""
                let redirectLocation:Option<String> = cache.getRedirectLocation()
                if(let Some(j) <- redirectLocation){
                    if(Util.isEmpty(j)){
                        url = info.getUrl()
                    }else{
                        url = j
                    }
                }else{
                    url = info.getUrl()
                }
                Util.d(TAG, "create connection on url: " + url)
                connection = Download4cj.withs().connectionFactory().create(url)
            }
             return connection.getOrThrow()
        }
    }

    func increaseCallbackBytes(increaseBytes:Int64):Unit{
        this.noCallbackIncreaseBytes += increaseBytes
    }

    func flushNoCallbackIncreaseBytes():Unit{
         if (noCallbackIncreaseBytes == 0){
            return
         }
        callbackDispatcher.dispatch().fetchProgress(task, blockIndex, noCallbackIncreaseBytes)
        noCallbackIncreaseBytes = 0
    }

    func start():Unit{
        let dispatcher:CallbackDispatcher =  Download4cj.withs().callbackDispatcher()
        // connect chain
        let retryInterceptor:RetryInterceptor = RetryInterceptor()
        let breakpointInterceptor:BreakpointInterceptor = BreakpointInterceptor()
        connectInterceptorList.add(retryInterceptor)
        connectInterceptorList.add(breakpointInterceptor)
        connectInterceptorList.add(HeaderInterceptor())
        connectInterceptorList.add(CallServerInterceptor())
        connectIndex = 0
        let connected:DownloadConnectionConnected = processConnect()
        if (cache.isInterrupt()) {
            throw InterruptException.SIGNAL
        }
        dispatcher.dispatch().fetchStart(task, blockIndex, getResponseContentLength())
        // fetch chain
        let fetchDataInterceptor:FetchDataInterceptor = FetchDataInterceptor(blockIndex, connected.getInputStream(),getOutputStream(), task)
        fetchInterceptorList.add(retryInterceptor)
        fetchInterceptorList.add(breakpointInterceptor)
        fetchInterceptorList.add(fetchDataInterceptor)
        fetchIndex = 0
        let totalFetchedBytes:Int64 = processFetch()
        dispatcher.dispatch().fetchEnd(task, blockIndex, totalFetchedBytes)
    }


    func releaseConnection():Unit{
        synchronized(m){
            if(let Some(i) <- connection){
                i.release()
            }
            connection = Option<DownloadConnection>.None
        }
    }


    func processConnect():DownloadConnectionConnected{

        if (cache.isInterrupt()){
            throw InterruptException.SIGNAL
        }

        let connect : InterceptorConnect = connectInterceptorList.get(connectIndex).getOrThrow()
        connectIndex++
        return connect.interceptConnect(this).getOrThrow()

    }

    func processFetch():Int64{
        if (cache.isInterrupt()){
           throw InterruptException.SIGNAL
        }

        let fetch : InterceptorFetch = fetchInterceptorList.get(fetchIndex).getOrThrow()
        fetchIndex++
        return fetch.interceptFetch(this)
    }

    func loopFetch():Int64{
        if (fetchIndex == fetchInterceptorList.size) {
            // last one is fetch data interceptor
            fetchIndex--
        }
        return processFetch()
    }

    func isFinished():Bool{
        return finished.load()
    }

    func getDownloadStore():DownloadStore{
        return store
    }

    func releaseConnectionAsync():Unit{
        spawn{
            releaseConnection()
        }
    }
}
