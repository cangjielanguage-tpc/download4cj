package okdownload

from net import tls.*

public class DownloadCall <: Equatable<DownloadCall>{

    let m:MultiConditionMonitor = MultiConditionMonitor()
    private static let TAG:String = "DownloadCall"
    static let MAX_COUNT_RETRY_FOR_PRECONDITION_FAILEDA:Int64 = 1
    let task:DownloadTask
    let asyncExecuted:Bool
    let blockChainList:ArrayList<DownloadChain>
    var cache:Option<DownloadCache>
    var canceled:Bool
    var finishing:Bool
    private let store:DownloadStore

    private init(task:DownloadTask,asyncExecuted:Bool,store:DownloadStore){
        this(task,asyncExecuted,ArrayList<DownloadChain>(),store)
    }

    init(task:DownloadTask,asyncExecuted:Bool,runningBlockList:ArrayList<DownloadChain>,store:DownloadStore){
        this.task = task
        this.asyncExecuted = asyncExecuted
        this.blockChainList = runningBlockList
        this.store = store
        this.cache = Option<DownloadCache>.None
        this.canceled = false
        this.finishing = false
    }

    static func create(task:DownloadTask,asyncExecuted:Bool,store:DownloadStore){
        return DownloadCall(task, asyncExecuted, store)
    }

    func cancel():Bool{
        synchronized(m){
            if (canceled){
                return false
            }

            if(finishing){
                return false
            }

            this.canceled = true
        }
        let startCancelTime:Int64 = DateTime.now().toUnixTimeStamp().toNanoseconds() / 1000 /1000
        OkDownload.withs().downloadDispatcher().flyingCanceled(this)
        let cache:Option<DownloadCache> = this.cache
        if(let Some(i) = cache){
            i.setUserCanceled()
        }
        let chains:Array<DownloadChain> = blockChainList.toArray()
        if(chains.size == 0){
              Util.d(TAG,"interrupt thread with cancel operation because of chains are not running "+ task.getId().toString())
        }else{
            for (chain in chains) {
                chain.cancel()
            }
        }

        if(let Some(i) = cache){
            i.getOutputStream().cancelAsync()
        }
        Util.d(TAG, "cancel task " + task.getId().toString() + " consume: " + (DateTime.now().toUnixTimeStamp().toNanoseconds() / 1000 /1000 - startCancelTime).toString() + "ms")
        return true
    }

    func isCanceled():Bool{
        return canceled
    }

    func isFinishing():Bool{
        return finishing
    }

    func executeCall():Unit{
        var retry:Bool = false
        var retryCount:Int64 = 0
        // ready param
        let okDownload:OkDownload = OkDownload.withs()
        let fileStrategy:ProcessFileStrategy = okDownload.processFileStrategy()
        //inspect task start
        inspectTaskStart()
        do{
            // 0. check basic param before start
            if(task.getUrl().size <= 0){
                this.cache = PreError(IOException("unexpected url: "+task.getUrl()))
                break
            }
             if (canceled){
                break
             }

             // 1. create basic info if not exist
             var info:BreakpointInfo
              try{
                var infoOnStore:Option<BreakpointInfo> = store.get(task.getId())
                if(let Some(i) = infoOnStore){
                    info = i
                }else{
                    info = store.createAndInsert(task)
                }
                setInfoToTask(info)
             }catch(e:IOException){
                 info = BreakpointInfo(0,"",Option<Directory>.None,"")
                 this.cache = PreError(e)
                break
             }
             if (canceled){
                break
             }
            // 2. remote check.
            let remoteCheck:BreakpointRemoteCheck = createRemoteCheck(info)
            try {
                remoteCheck.check()
            } catch (e:ReadWriteException) {
                break
            }
            // ready cache.
            let cachea:DownloadCache = createCache(info)
            this.cache = cachea
            if(!Util.isEmpty(task.getRedirectLocation())){
                cache.getOrThrow().setRedirectLocation(task.getRedirectLocation())
            }
            // 3. waiting for file lock release after file path is confirmed.
              // 4. reuse another info if another info is idle and available for reuse.
            OkDownload.withs().downloadStrategy().inspectAnotherSameInfo(task, info, remoteCheck.getInstanceLength())
            try{
                 if (remoteCheck.isResumable()) {
                         // 5. local check
                    let localCheck:BreakpointLocalCheck = createLocalCheck(info,remoteCheck.getInstanceLength())
                    localCheck.check()
                    if(localCheck.isDirty()) {
                        Util.d(TAG, "breakpoint invalid: download from beginning because of local check is dirty "+task.getId().toString()+" "+localCheck.toString())
                         // 6. assemble block data
                        fileStrategy.discardProcess(task)
                        assembleBlockAndCallbackFromBeginning(info,remoteCheck)
                    }else{
                         okDownload.callbackDispatcher().dispatch().downloadFromBreakpoint(task)
                    }
                 }
            }catch(e:IOException){
                cache.getOrThrow().setUnknownError(e)
                break
            }

            // 7. start with cache and info.
            start(cache.getOrThrow(), info)

            if (canceled){
                break
            }

             // 8. retry if precondition failed.
            retryCount++
            if (cache.getOrThrow().isPreconditionFailed() && retryCount < MAX_COUNT_RETRY_FOR_PRECONDITION_FAILEDA) {
                //移除对应的id
                store.remove(task.getId())
                //重新开始
                retry = true
            } else {
                //不用重新开始
                retry = false
            }
        }while(retry)

        // finish
        finishing = true
        blockChainList.clear()

        let cache:Option<DownloadCache> = this.cache
        if (canceled){
            return
        }

        if(let Some(_) = cache){
        }else{
            return
        }

        var cause:EndCause = EndCause.COMPLETED
        var realCause:Option<Exception> = Option<Exception>.None
        if (cache.getOrThrow().isServerCanceled() || cache.getOrThrow().isUnknownError() || cache.getOrThrow().isPreconditionFailed()) {
            cause = EndCause.ERROR
            realCause = cache.getOrThrow().getRealCause()
        } else if (cache.getOrThrow().isFileBusyAfterRun()) {
            cause = EndCause.FILE_BUSY
        } else if (cache.getOrThrow().isPreAllocateFailed()) {
            cause = EndCause.PRE_ALLOCATE_FAILED
            realCause = cache.getOrThrow().getRealCause()
        } else {
            cause = EndCause.COMPLETED
        }
         inspectTaskEnd(cause, realCause)
    }

    private func inspectTaskStart():Unit{
        store.onTaskStart(task.getId())
        OkDownload.withs().callbackDispatcher().dispatch().taskStart(task)
    }

    private func inspectTaskEnd(cause:EndCause,realCause:Option<Exception>){

        synchronized(m){
            if (canceled){
                return
            }
            finishing = true
        }
        store.onTaskEnd(task.getId(), cause, realCause)
        match(cause){
            case EndCause.COMPLETED =>
                store.markFileClear(task.getId())
            case _ =>  println("cause not complete")
        }
        OkDownload.withs().callbackDispatcher().dispatch().taskEnd(task, realCause)

    }

    func createCache(info:BreakpointInfo):DownloadCache{
        let outputStream:MultiPointOutputStream = OkDownload.withs().processFileStrategy().createProcessStream(task, info, store)
        return DownloadCache(outputStream)
    }

    func getPriority():Int64 {
        return task.getPriority()
    }

    func start(cache:DownloadCache,info:BreakpointInfo):Unit{
        let blockCount:Int64 = info.getBlockCount()
        let blockChainList:ArrayList<DownloadChain> = ArrayList<DownloadChain>(info.getBlockCount())
        let blockIndexList:ArrayList<Int64> = ArrayList<Int64>()
        for(i in 0..blockCount){
            let blockInfo:BlockInfo = info.getBlock(i).getOrThrow()
            if (Util.isCorrectFull(blockInfo.getCurrentOffset(), blockInfo.getContentLength())) {
                continue
            }
            Util.resetBlockIfDirty(blockInfo)
            let chain:DownloadChain = DownloadChain.createChain(i, task, info, cache, store)
            blockChainList.append(chain)
            blockIndexList.append(chain.getBlockIndex())
        }

        if (canceled) {
            return
        }

        cache.getOutputStream().setRequireStreamBlocks(blockIndexList)
        startBlocks(blockChainList)

    }

    func startBlocks(tasks:ArrayList<DownloadChain>):Unit{

        var futures:ArrayList<Future<Unit>> = ArrayList<Future<Unit>>(tasks.size)

        try{
            for(i in 0..tasks.size){
                let fut : Future<Unit> = spawn{ =>
                    let task:DownloadChain = tasks.get(i).getOrThrow()
                    if(task.isFinished()){
                        throw  IllegalAccessException("The chain has been finished!")
                    }
                    try{
                        task.start()
                    }catch(e:Exception){
                    }finally{
                        try{
                            task.finished.store(true)
                            task.releaseConnectionAsync()
                        }catch(e:Exception){

                        }
                    }
                }
                futures.append(fut)
            }
            blockChainList.appendAll(tasks)
            for(future in futures){
                future.get()
            }

        }catch(e:Exception){
            throw e
        }finally{
            doDelete(blockChainList,tasks)
        }
    }

    private func doDelete(blockChainList:ArrayList<DownloadChain>,tasks:ArrayList<DownloadChain>){
        blockChainList.removeIf(
            {blockChain:DownloadChain =>
                var isRight = false
                for(task in tasks){
                    if(task.getTask().getId() == blockChain.getTask().getId()){
                        isRight = true
                        break
                    }
                }
                return isRight
            }
        )
    }

    func createLocalCheck(info:BreakpointInfo,responseInstanceLength:Int64):BreakpointLocalCheck{
        return BreakpointLocalCheck(task, info, responseInstanceLength)
    }

    func createRemoteCheck(info:BreakpointInfo):BreakpointRemoteCheck{
        return BreakpointRemoteCheck(task, info)
    }

    func setInfoToTask(info:BreakpointInfo):Unit{
        TaskHideWrapper.setBreakpointInfo(task, info)
    }

    func assembleBlockAndCallbackFromBeginning(info:BreakpointInfo,remoteCheck:BreakpointRemoteCheck):Unit{
        Util.assembleBlock(task, info, remoteCheck.getInstanceLength(),remoteCheck.isAcceptRange())
        OkDownload.withs().callbackDispatcher().dispatch().downloadFromBeginning(task)
    }

    public operator func ==(that: DownloadCall): Bool{
        return refEq(task,that.task)
    }

    public operator func !=(that: DownloadCall): Bool{
        return !refEq(task,that.task)
    }
}
