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
                    if (inspectCompleted(task)){
                        continue
                    }
                    enqueueIgnorePriority(task)
                }
                OkDownload.withs().callbackDispatcher().endTasks(completedTaskList, sameTaskConflictList, fileBusyList)
            }catch(e:Exception){
            }
        }
    }


    private func enqueueLocked(task:DownloadTask):Unit{
        synchronized(m){
            if (inspectCompleted(task)){
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

            call = DownloadCall.create(task, false, store.getOrThrow())
            runningSyncCalls.append(call)
        }
        call.execute()
    }





    //检查是否完成
    func inspectCompleted(task:DownloadTask):Bool{
        let store:BreakpointStore = OkDownload.withs().breakpointStore()
        let isOnlyMemoryCache = store.isOnlyMemoryCache()
        //目前是isOnlyMemoryCache true 根据规则true的时候为false
        if(isOnlyMemoryCache){
            return false
        }else{
            return true
        }
    }



    private func runningAsyncSize():Int64{
        return runningAsyncCalls.size - flyingCanceledAsyncCallCount.load()
    }



}
