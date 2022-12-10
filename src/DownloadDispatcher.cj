package okdownload

public class DownloadDispatcher{

    let m:MultiConditionMonitor = MultiConditionMonitor()



    private static let TAG:String = "DownloadDispatcher"
    var maxParallelRunningCount:Int64 = 5
    //对于排序性能（不需要复制一个数组），使用ArrayList而不是deque（对于顶部添加，底部删除）。
    private let readyAsyncCalls:ArrayList<DownloadCall>
    private let runningAsyncCalls:ArrayList<DownloadCall>
    private let runningSyncCalls:ArrayList<DownloadCall>

    //用于在任务完成期间将任务排队
    private let finishingCalls:ArrayList<DownloadCall>
    //任务已取消，但尚未从runningAsyncCalls列表中删除。
    private let flyingCanceledAsyncCallCount:AtomicInt64 = AtomicInt64(0)

    //用于在执行排队/取消操作时避免processCalls
    private let skipProceedCallCount:AtomicInt64 = AtomicInt64(0)

    var store:Option<DownloadStore>

    public init(){
        this(ArrayList<DownloadCall>(),ArrayList<DownloadCall>(),ArrayList<DownloadCall>(),ArrayList<DownloadCall>())
    }

    init(readyAsyncCalls:ArrayList<DownloadCall>,runningAsyncCalls:ArrayList<DownloadCall>,
                runningSyncCalls:ArrayList<DownloadCall>,finishingCalls:ArrayList<DownloadCall>){
        this.readyAsyncCalls = readyAsyncCalls
        this.runningAsyncCalls = runningAsyncCalls
        this.runningSyncCalls = runningSyncCalls
        this.finishingCalls = finishingCalls
        this.store = Option<DownloadStore>.None
    }

    public func setDownloadStore(store:DownloadStore):Unit{
        this.store = store
    }

    public func execute(task:DownloadTask):Unit{
        let call:DownloadCall
        synchronized (m) {
            println("bbbb")
            if (inspectCompleted(task)) {
                return
            }
            println("cccc")
            if(inspectForConflict(task)){
                return
            }
            println("dddd")
            call = DownloadCall.create(task, false, store.getOrThrow())
            runningSyncCalls.append(call)
        }
        call.execute()
    }


    //......


    //......




    //......



    //......










    func inspectCompleted(task:DownloadTask):Bool{
        return inspectCompleted(task,None<ArrayList<DownloadTask>>)
    }

    //检查是否完成
    func inspectCompleted(task:DownloadTask,completedCollection:Option<ArrayList<DownloadTask>>):Bool{

        if(task.isPassIfAlreadyCompleted()){
        //if(task.isPassIfAlreadyCompleted() && StatusUtil.isCompleted(task)){
            //是否已结束
            //如果文件名不正常，为空就没结束 应该这个意思

            //------

            OkDownload.withs().callbackDispatcher().dispatch().taskEnd(task, EndCause.COMPLETED, Option<Exception>.None);

            return true
        }

        return false
    }




    public func isFileConflictAfterRun(task:DownloadTask):Bool{
        synchronized(m){
            Util.d(TAG, "is file conflict after run: " + task.getId().toString())
            let file:Option<File> = task.getFile()
            if(let Some(i) = file){

            }else{
                return false
            }

            for(syncCall in runningSyncCalls){
                if(syncCall.isCanceled() || (refEq(syncCall.task,task))){
                    continue
                }

                //------

            }

            for(asyncCall in runningAsyncCalls){
                //------

            }

             return false
        }
    }





    private func inspectForConflict(task:DownloadTask):Bool{
        return inspectForConflict(task, Option<ArrayList<DownloadTask>>.None, Option<ArrayList<DownloadTask>>.None)
    }


    private func inspectForConflict(task:DownloadTask,sameTaskList:Option<ArrayList<DownloadTask>>,fileBusyList:Option<ArrayList<DownloadTask>>):Bool{
        return inspectForConflict(task, readyAsyncCalls, sameTaskList, fileBusyList)
                || inspectForConflict(task, runningAsyncCalls, sameTaskList, fileBusyList)
                || inspectForConflict(task, runningSyncCalls, sameTaskList, fileBusyList)
    }

    func inspectForConflict(task:DownloadTask,calls:ArrayList<DownloadCall>,sameTaskList:Option<ArrayList<DownloadTask>>,fileBusyList:Option<ArrayList<DownloadTask>>):Bool{
        let callbackDispatcher:CallbackDispatcher = OkDownload.withs().callbackDispatcher()
        let iterator:Iterator<DownloadCall> = calls.iterator()
        while(true){
            var optCall:Option<DownloadCall> = iterator.next()
            match(optCall){
                case Some(v)=>
                    println("")
                    //------

                case None => break
            }
        }
        return false
    }




    //......




    //------




   //......


    //......






}
