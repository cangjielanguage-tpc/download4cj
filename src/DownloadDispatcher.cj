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

     init(){
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

     func setDownloadStore(store:DownloadStore):Unit{
        this.store = store
    }



     func enqueue(tasks:Array<DownloadTask>):Unit{
        skipProceedCallCount.fetchAdd(1)
        enqueueLocked(tasks)
        skipProceedCallCount.fetchSub(1)
    }

     func enqueue(task:DownloadTask):Unit{
        skipProceedCallCount.fetchAdd(1)
        enqueueLocked(task)
        skipProceedCallCount.fetchSub(1)
    }

    private func enqueueLocked(tasks:Array<DownloadTask>):Unit{
        synchronized(m){
            let taskList:ArrayList<DownloadTask>  = ArrayList<DownloadTask>()
            taskList.appendAll(tasks)
            if(taskList.size > 1){
                taskList.sortBy({rht:DownloadTask,lht:DownloadTask =>
                    if(rht.getPriority() < lht.getPriority()){
                        return Ordering.GT
                    }
                    if(rht.getPriority() > lht.getPriority()){
                        return Ordering.LT
                    }
                    return Ordering.EQ
                },stable:true)
            }

            let originReadyAsyncCallSize:Int64 = readyAsyncCalls.size
            try{
                let completedTaskList:ArrayList<DownloadTask> = ArrayList<DownloadTask>()
                let sameTaskConflictList:ArrayList<DownloadTask> = ArrayList<DownloadTask>()
                let fileBusyList:ArrayList<DownloadTask> = ArrayList<DownloadTask>()
                for(task in taskList){
                    if (inspectCompleted(task, completedTaskList)){
                        continue
                    }
                    if (inspectForConflict(task, sameTaskConflictList, fileBusyList)){
                        continue
                    }
                    enqueueIgnorePriority(task)
                }
                OkDownload.withs().callbackDispatcher().endTasks(completedTaskList, sameTaskConflictList, fileBusyList)
            }catch(e:Exception){
                //let errorList:ArrayList<DownloadTask> = ArrayList<DownloadTask>(taskList)
                //OkDownload.withs().callbackDispatcher().endTasksWithError(errorList, e)
            }
        }
    }


    private func enqueueLocked(task:DownloadTask):Unit{
        synchronized(m){
            if (inspectCompleted(task)){
                return
            }
            if (inspectForConflict(task)){
                return
            }
            let originReadyAsyncCallSize:Int64 = readyAsyncCalls.size
            enqueueIgnorePriority(task)
        }
    }




    private func enqueueIgnorePriority(task:DownloadTask):Unit{
        let call:DownloadCall = DownloadCall.create(task, true, store.getOrThrow())
        if (runningAsyncSize() < maxParallelRunningCount) {
            runningAsyncCalls.append(call)
            spawn{=>
                call.execute()
            }
        } else {
            readyAsyncCalls.append(call)
        }
    }





     func execute(task:DownloadTask):Unit{
        let call:DownloadCall
        synchronized (m) {
            if (inspectCompleted(task)) {
                return
            }
            if(inspectForConflict(task)){
                return
            }
            call = DownloadCall.create(task, false, store.getOrThrow())
            runningSyncCalls.append(call)
        }
        call.execute()
    }



    func inspectCompleted(task:DownloadTask):Bool{
        return inspectCompleted(task,None<ArrayList<DownloadTask>>)
    }

    //检查是否完成
    func inspectCompleted(task:DownloadTask,completedCollection:Option<ArrayList<DownloadTask>>):Bool{
        let store:BreakpointStore = OkDownload.withs().breakpointStore()
        let isOnlyMemoryCache = store.isOnlyMemoryCache()
        if(task.isPassIfAlreadyCompleted() && !isOnlyMemoryCache){
         //那就要判断有没有已经下载好文件了

        //if(task.isPassIfAlreadyCompleted() && StatusUtil.isCompleted(task)){
            //是否已结束
            //如果文件名不正常，为空就没结束 应该这个意思

            //------

            //OkDownload.withs().callbackDispatcher().dispatch().taskEnd(task, EndCause.COMPLETED, Option<Exception>.None);
            //目前这里进不来因为isOnlyMemoryCache
            // OkDownload.withs().callbackDispatcher().dispatch().taskEnd(task, Option<Exception>.None)

            // return true
        }

        return false
    }




     func isFileConflictAfterRun(task:DownloadTask):Bool{
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

            }

            for(asyncCall in runningAsyncCalls){

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
                case Some(v)=>v
                    //------
                case None => break
            }
        }
        return false
    }


    private func runningAsyncSize():Int64{
        return runningAsyncCalls.size - flyingCanceledAsyncCallCount.load()
    }



}
