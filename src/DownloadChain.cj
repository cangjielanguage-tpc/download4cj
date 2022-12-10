package okdownload

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
        this.callbackDispatcher = OkDownload.withs().callbackDispatcher()
        this.connection = Option<DownloadConnection>.None
        this.noCallbackIncreaseBytes = 0
    }


    public func getResponseContentLength():Int64{
        return responseContentLength
    }

    public func setResponseContentLength(responseContentLength:Int64):Unit{
        this.responseContentLength = responseContentLength
    }



    //......


    public func getTask():DownloadTask{
        return task
    }

    public func getInfo():BreakpointInfo{
        return this.info
    }


    public func getBlockIndex():Int64{
        return blockIndex
    }

    //------


    public func getCache():DownloadCache{
        return cache
    }


    //------


    public func getOutputStream():MultiPointOutputStream{
        return  this.cache.getOutputStream()
    }

    //------


    public func getConnectionOrCreate():DownloadConnection{
        synchronized(m){

            if (cache.isInterrupt()){
                throw InterruptException.SIGNAL
            }
            if(let Some(i) = connection){

            }else{
                //为空
                var url:String = ""
                let redirectLocation:Option<String> = cache.getRedirectLocation()
                if(let Some(j) = redirectLocation){
                    if(Util.isEmpty(j)){
                        url = info.getUrl()
                    }else{
                        url = j
                    }
                }else{
                    url = info.getUrl()
                }
                Util.d(TAG, "create connection on url: " + url)
                connection = OkDownload.withs().connectionFactory().create(url)
            }
             return connection.getOrThrow()
        }
    }


    public func increaseCallbackBytes(increaseBytes:Int64):Unit{
        this.noCallbackIncreaseBytes += increaseBytes
    }

    public func flushNoCallbackIncreaseBytes():Unit{
         if (noCallbackIncreaseBytes == 0){
            return
         }
        callbackDispatcher.dispatch().fetchProgress(task, blockIndex, noCallbackIncreaseBytes)
        noCallbackIncreaseBytes = 0
    }



    func start():Unit{
        //------TODO
    }




    public func resetConnectForRetry():Unit{
        //------

    }

    public func releaseConnection():Unit{
        synchronized(m){
            if(let Some(i) = connection){
                i.release()
                //Util.d(TAG, "release connection  connection.toString()  task[" + task.getId().toString()+ "] block[" + blockIndex.toString() + "]")
            }
            connection = Option<DownloadConnection>.None
        }
    }


    public func processConnect():DownloadConnectionConnected{

        if (cache.isInterrupt()){
            throw InterruptException.SIGNAL
        }

        let connect : InterceptorConnect = connectInterceptorList.get(connectIndex).getOrThrow()
        connectIndex++
        return connect.interceptConnect(this).getOrThrow()

    }



    public func processFetch():Int64{
        if (cache.isInterrupt()){
            //------

        }

        let fetch : InterceptorFetch = fetchInterceptorList.get(fetchIndex).getOrThrow()
        fetchIndex++
        return fetch.interceptFetch(this)
    }



    public func loopFetch():Int64{
        if (fetchIndex == fetchInterceptorList.size) {
            // last one is fetch data interceptor
            fetchIndex--
        }
        return processFetch()
    }

    func isFinished():Bool{
        return finished.load()
    }


    public func getDownloadStore():DownloadStore{
        return store
    }


    func releaseConnectionAsync():Unit{
        spawn{
            releaseConnection()
        }
    }






}
