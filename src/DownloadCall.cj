package okdownload

public class DownloadCall <: Equatable<DownloadCall>{


    let m:MultiConditionMonitor = MultiConditionMonitor()


    private static let TAG:String = "DownloadCall"
    static let MAX_COUNT_RETRY_FOR_PRECONDITION_FAILED:Int64 = 1
    public let task:DownloadTask
    public let asyncExecuted:Bool
    let blockChainList:ArrayList<DownloadChain>
    var cache:Option<DownloadCache>
    var canceled:Bool
    var finishing:Bool
    //volatile Thread currentThread
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


    public static func create(task:DownloadTask,asyncExecuted:Bool,store:DownloadStore){
        return DownloadCall(task, asyncExecuted, store)
    }


    //......




    public func isCanceled():Bool{
        return  canceled
    }


    //......



    public func execute():Unit{
        //currentThread = Thread.currentThread();
        println("dddd")
        var retry:Bool = false
        var retryCount:Int64 = 0
        // ready param
        let okDownload:OkDownload = OkDownload.withs()
        let fileStrategy:ProcessFileStrategy = okDownload.processFileStrategy()
        //inspect task start
        println("eeee")

        inspectTaskStart()
        println("ffff")

        do{
            println("ffffff")
            // 0. check basic param before start
            if(task.getUrl().size <= 0){
                this.cache = PreError(IOException("unexpected url: "+task.getUrl()))
                break
            }
            println("gggggg1")
             if (canceled){
                break
             }

             // 1. create basic info if not exist
             var info:BreakpointInfo
              try{
                println("hhhhhh2")
                var infoOnStore:Option<BreakpointInfo> = store.get(task.getId())
                if(let Some(i) = infoOnStore){
                    //已经存在
                    info = i
                }else{
                    println("hhhhhh3")
                    info = store.createAndInsert(task)
                }
                println("hhhhhh4")
                setInfoToTask(info)
                println("hhhhhh5")
             }catch(e:IOException){
                 info = BreakpointInfo(0,"",Option<Directory>.None,"")
                 this.cache = PreError(e)
                break
             }
             if (canceled){
                break
             }
            println("iiiiiii")
            // ready cache.
            let cachea:DownloadCache = createCache(info)
            this.cache = cachea
            println("jjjjjj")

            // 2. remote check.
            let remoteCheck:BreakpointRemoteCheck = createRemoteCheck(info)
            try {
                println("mmmmm88")
                remoteCheck.check()



            } catch (e:IOException) {
                //------

                break
            }


            println("mmmmmmm40")

            if(!Util.isEmpty(task.getRedirectLocation())){
                cache.getOrThrow().setRedirectLocation(task.getRedirectLocation())
            }
            // 3. waiting for file lock release after file path is confirmed.
            println("kkkkkkk1111")
              // 4. reuse another info if another info is idle and available for reuse.
            OkDownload.withs().downloadStrategy().inspectAnotherSameInfo(task, info, remoteCheck.getInstanceLength())
            println("llllllll2222")
            try{
                 if (remoteCheck.isResumable()) {
                         // 5. local check

                    println("llllllll3333")
                    let localCheck:BreakpointLocalCheck = createLocalCheck(info,remoteCheck.getInstanceLength())
                    println("llllllll4444")
                    localCheck.check()
                    println("llllllll5555")
                    if(localCheck.isDirty()) {
                         println("llllllll6666")
                        Util.d(TAG, "breakpoint invalid: download from beginning because of local check is dirty "+task.getId().toString()+" "+localCheck.toString())
                         // 6. assemble block data
                        fileStrategy.discardProcess(task)
                        assembleBlockAndCallbackFromBeginning(info,remoteCheck,localCheck.getCauseOrThrow())
                    }else{
                         //println("llllllll7777")
                         okDownload.callbackDispatcher().dispatch().downloadFromBreakpoint(task, info)
                    }
                 }else{
                    //------

                 }
            }catch(e:IOException){
                cache.getOrThrow().setUnknownError(e)
                break
            }

            println("mmmmmmmm")
            // 7. start with cache and info.
            start(cache.getOrThrow(), info)

            //break

            if (canceled){
                break
            }

             // 8. retry if precondition failed.
            retryCount++
            if (cache.getOrThrow().isPreconditionFailed() && retryCount < MAX_COUNT_RETRY_FOR_PRECONDITION_FAILED) {
                store.remove(task.getId())
                retry = true
            } else {
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

        if(let Some(i) = cache){

        }else{
            return
        }

        var cause:EndCause = EndCause.COMPLETED
        var realCause:Option<Exception> = Option<Exception>.None
        if (cache.getOrThrow().isServerCanceled() || cache.getOrThrow().isUnknownError() || cache.getOrThrow().isPreconditionFailed()) {
            // error
            //------
        } else if (cache.getOrThrow().isFileBusyAfterRun()) {
            //------
        } else if (cache.getOrThrow().isPreAllocateFailed()) {
            //------
        } else {
            cause = EndCause.COMPLETED
        }
         inspectTaskEnd(cache.getOrThrow(), cause, realCause)
    }

    private func inspectTaskStart():Unit{
        store.onTaskStart(task.getId())
        println("gggggg")
        OkDownload.withs().callbackDispatcher().dispatch().taskStart(task)
        println("hhhhh")
    }


      private func inspectTaskEnd(cache:DownloadCache,cause:EndCause,realCause:Option<Exception>){
        // match(cause){
        //     case EndCause.CANCELED =>  throw IllegalAccessException("can't recognize cancelled on here")
        //     case _ => println("cause not cancel")
        // }
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
                //OkDownload.withs().processFileStrategy().completeProcessStream(cache.getOutputStream(), task)
            case _ =>  println("cause not complete")
        }
        OkDownload.withs().callbackDispatcher().dispatch().taskEnd(task, cause, realCause)
    }





    func createCache(info:BreakpointInfo):DownloadCache{
        let outputStream:MultiPointOutputStream = OkDownload.withs().processFileStrategy().createProcessStream(task, info, store)
        return DownloadCache(outputStream)
    }

    //------



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
        println("startblocks")
        println("开始下载了************************************************************************************************************************************************")
        startBlocks(blockChainList)

    }

    //------



    //------



    func startBlocks(tasks:ArrayList<DownloadChain>):Unit{

        var futures:ArrayList<Future<Unit>> = ArrayList<Future<Unit>>(tasks.size)

        try{
            println("下载开始了000     blockIndex===")
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
                        task.finished.store(true)
                        task.releaseConnectionAsync()
                    }
                }
                futures.append(fut)
            }
            blockChainList.appendAll(tasks)
            for(future in futures){
                future.getResult()
                println("下载开始了AAA     blockIndex===")
            }

        }catch(e:Exception){
            throw e
        }finally{
            println("下载开始了CCC     blockIndex===")
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
                    }else{

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


    func assembleBlockAndCallbackFromBeginning(info:BreakpointInfo,remoteCheck:BreakpointRemoteCheck,failedCause:ResumeFailedCause):Unit{
        Util.assembleBlock(task, info, remoteCheck.getInstanceLength(),remoteCheck.isAcceptRange())
        OkDownload.withs().callbackDispatcher().dispatch().downloadFromBeginning(task, info, failedCause)
    }



    public func equalsTask(thatTask:DownloadTask):Bool{
        return this.task == thatTask
    }



    public func getFile():Option<File>{
        return this.task.getFile()
    }


    public operator func ==(anothor: DownloadCall): Bool{
        return true
        //------

    }



    public operator func !=(anothor: DownloadCall): Bool{
        return false
        //------

    }

}
