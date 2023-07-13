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
                    if (inspectCompleted()){
                        continue
                    }

                    if(inspectForConflict(task, sameTaskConflictList, fileBusyList)){
                        continue
                    }
                    enqueueIgnorePriority(task)
                }
                OkDownload.withs().callbackDispatcher().endTasks(completedTaskList, sameTaskConflictList, fileBusyList)
            }catch(e:Exception){
            }
            if(originReadyAsyncCallSize != readyAsyncCalls.size){
                readyAsyncCalls.sortBy({rht:DownloadCall,lht:DownloadCall =>
                    if(rht.getPriority() < lht.getPriority()){
                        return Ordering.GT
                    }
                    if(rht.getPriority() > lht.getPriority()){
                        return Ordering.LT
                    }
                    return Ordering.EQ
                },stable:true)
            }

        }
    }

    private func enqueueLocked(task:DownloadTask):Unit{
        synchronized(m){
            if (inspectCompleted()){
                return
            }

            if (inspectForConflict(task)){
                return
            }

            let originReadyAsyncCallSize:Int64 = readyAsyncCalls.size
            enqueueIgnorePriority(task)
            if(originReadyAsyncCallSize != readyAsyncCalls.size){
                readyAsyncCalls.sortBy({rht:DownloadCall,lht:DownloadCall =>
                    if(rht.getPriority() < lht.getPriority()){
                        return Ordering.GT
                    }
                    if(rht.getPriority() > lht.getPriority()){
                        return Ordering.LT
                    }
                    return Ordering.EQ
                },stable:true)
            }
        }
    }

    private func enqueueIgnorePriority(task:DownloadTask):Unit{
        let call:DownloadCall = DownloadCall.create(task, true, store.getOrThrow())
        if (runningAsyncSize() < maxParallelRunningCount) {
            runningAsyncCalls.append(call)
            spawn{=>
                try{
                    call.executeCall()
                }finally{
                    finish(call)
                }
            }
        } else {
            readyAsyncCalls.append(call)
        }
    }

    func execute(task:DownloadTask):Unit{
        let call:DownloadCall
        synchronized (m) {
            if (inspectCompleted()) {
                return
            }

            if (inspectForConflict(task)){
                return
            }

            call = DownloadCall.create(task, false, store.getOrThrow())
            runningSyncCalls.append(call)
        }
        try{
            call.executeCall()
        }finally{
            finish(call)
        }
    }

    func cancel(tasks:Array<DownloadTask>):Unit{
        skipProceedCallCount.fetchAdd(1)
        cancelLocked(tasks)
        skipProceedCallCount.fetchSub(1)
    }

    func cancel(task:DownloadTask):Bool{
        skipProceedCallCount.fetchAdd(1)
        let result:Bool = cancelLocked(task)
        skipProceedCallCount.fetchSub(1)
        return result
    }

    private func cancelLocked(tasks:Array<DownloadTask>):Unit{
        synchronized(m){
            let startCancelTime:Int64 = DateTime.now().toUnixTimeStamp().toNanoseconds()/1000/1000
            Util.d(TAG, "start cancel bunch task manually: " + tasks.size.toString())
            let needCallbackCalls:ArrayList<DownloadCall> = ArrayList<DownloadCall>()
            let needCancelCalls:ArrayList<DownloadCall> = ArrayList<DownloadCall>()
            try {
                for (task in tasks) {
                    filterCanceledCalls(task, needCallbackCalls, needCancelCalls)
                }
            }finally{
                handleCanceledCalls(needCallbackCalls, needCancelCalls)
                 let endCancelTime:Int64 = DateTime.now().toUnixTimeStamp().toNanoseconds()/1000/1000
                Util.d(TAG,"finish cancel bunch task manually: " + tasks.size.toString() + " consume "+(endCancelTime - startCancelTime).toString() + "ms")
            }
        }
    }

    func cancelLocked(task:DownloadTask):Bool{
        synchronized(m){
            Util.d(TAG, "cancel manually: " + task.getId().toString())
            let needCallbackCalls:ArrayList<DownloadCall> = ArrayList<DownloadCall>()
            let needCancelCalls:ArrayList<DownloadCall> = ArrayList<DownloadCall>()
            try{
                filterCanceledCalls(task, needCallbackCalls, needCancelCalls)
            }finally{
                handleCanceledCalls(needCallbackCalls, needCancelCalls)
            }
            return needCallbackCalls.size > 0 || needCancelCalls.size > 0
        }
    }

    private func filterCanceledCalls(task:DownloadTask,needCallbackCalls:ArrayList<DownloadCall>,needCancelCalls:ArrayList<DownloadCall>){
        synchronized(m){
            let TempreadyAsyncCalls:ArrayList<DownloadCall> = ArrayList<DownloadCall>()
            for(call in readyAsyncCalls){
                TempreadyAsyncCalls.append(call)
            }
            for(call in TempreadyAsyncCalls){
                if(refEq(call.task,task) ||  call.task.getId() == task.getId()){
                    if (call.isCanceled() || call.isFinishing()){
                        return
                    }

                    readyAsyncCalls.removeIf({mycall:DownloadCall =>
                        let myTask:DownloadTask = mycall.task
                        let b =  refEq(myTask,task)
                        return b
                    })

                    needCallbackCalls.append(call)
                    return
                }
            }

            for (call in runningAsyncCalls) {
                if (refEq(call.task,task) || call.task.getId() == task.getId()) {
                    needCallbackCalls.append(call)
                    needCancelCalls.append(call)
                    return
                }
            }

            for (call in runningSyncCalls) {
                if (refEq(call.task,task) || call.task.getId() == task.getId()) {
                    needCallbackCalls.append(call)
                    needCancelCalls.append(call)
                    return
                }
            }
        }
    }

    private func handleCanceledCalls(needCallbackCalls:ArrayList<DownloadCall>,needCancelCalls:ArrayList<DownloadCall>){
        synchronized(m){
            Util.d(TAG, "handle cancel calls, cancel calls: " + needCancelCalls.size.toString())

           if (!needCancelCalls.isEmpty()) {
                for(call in needCancelCalls){
                     if (!call.cancel()) {
                        needCallbackCalls.removeIf({mycall:DownloadCall =>
                            let myTask:DownloadTask = mycall.task
                            let b = refEq(myTask,call.task)
                            return b
                        })
                     }
                }
           }

            Util.d(TAG, "handle cancel calls, callback cancel event: " + needCallbackCalls.size.toString())
            if (!needCallbackCalls.isEmpty()) {
                if (needCallbackCalls.size <= 1) {
                    let call:DownloadCall = needCallbackCalls.get(0).getOrThrow()
                    OkDownload.withs().callbackDispatcher().dispatch().taskEnd(call.task,Option<Exception>.None)
                } else {
                    let callbackCanceledTasks:ArrayList<DownloadTask> = ArrayList<DownloadTask>()
                    for (call in needCallbackCalls) {
                        callbackCanceledTasks.append(call.task)
                    }
                    OkDownload.withs().callbackDispatcher().endTasksWithCanceled(callbackCanceledTasks)
                }
            }
        }
    }

    func flyingCanceled(call:DownloadCall):Unit{
        synchronized(m){
            Util.d(TAG, "flying canceled: " + call.task.getId().toString())
            if (call.asyncExecuted){
                flyingCanceledAsyncCallCount.fetchAdd(1)
            }
        }
    }

    func finish(call:DownloadCall):Unit{
        synchronized(m){
            let asyncExecuted:Bool = call.asyncExecuted
            var callsa:ArrayList<DownloadCall> = ArrayList<DownloadCall>()
            if(finishingCalls.contains(call)){
                callsa = finishingCalls
            }else if(asyncExecuted){
                callsa = runningAsyncCalls
            }else{
                callsa = runningSyncCalls
            }
            try{
                callsa.removeIf({mycall:DownloadCall =>
                    let myTask:DownloadTask = mycall.task
                    let b = refEq(myTask,call.task)
                    return b
                })
            }catch(e:Exception){
                throw IllegalStateException("Call wasn't in-flight!")
            }
            if (asyncExecuted && call.isCanceled()){
                flyingCanceledAsyncCallCount.fetchSub(1)
            }
            if (asyncExecuted){
                 processCalls()
            }
        }
    }


    private func inspectForConflict(task:DownloadTask):Bool{
        return inspectForConflict(task,Option<ArrayList<DownloadTask>>.None,Option<ArrayList<DownloadTask>>.None)
    }


    private func inspectForConflict(task:DownloadTask,sameTaskList:Option<ArrayList<DownloadTask>>,fileBusyList:Option<ArrayList<DownloadTask>>){
        let resultA = inspectForConflict(task, readyAsyncCalls, sameTaskList, fileBusyList)
        let resultB = inspectForConflict(task, runningAsyncCalls, sameTaskList, fileBusyList)
        let resultC = inspectForConflict(task, runningSyncCalls, sameTaskList, fileBusyList)
        return resultA||resultB||resultC
    }


    //检查是否完成
    func inspectCompleted():Bool{
        let store:BreakpointStore = OkDownload.withs().breakpointStore()
        let isOnlyMemoryCache = store.isOnlyMemoryCache()
        //目前是isOnlyMemoryCache true 根据规则true的时候为false
        if(isOnlyMemoryCache){
            return false
        }else{
            return true
        }
    }


    func inspectForConflict(task:DownloadTask,calls:ArrayList<DownloadCall>,sameTaskList:Option<ArrayList<DownloadTask>>,fileBusyList:Option<ArrayList<DownloadTask>>){
        let callbackDispatcher:CallbackDispatcher = OkDownload.withs().callbackDispatcher()
        let TempCalls:ArrayList<DownloadCall> = ArrayList<DownloadCall>()
        for(call in calls){
            TempCalls.append(call)
        }
        for(call in TempCalls){
            if(call.isCanceled()){
                continue
            }

            if(refEq(call.task,task)||call.task.getId() == task.getId()){
                if(call.isFinishing()){
                    Util.d(TAG, "task: "+task.getId().toString()+" is finishing, move it to finishing list")
                    finishingCalls.append(call)
                    calls.removeIf({mycall:DownloadCall =>
                        let b = refEq(mycall,call)
                        return b
                    })
                    return false
                }

                if(let Some(i) = sameTaskList){
                    i.append(task)
                }else{
                    callbackDispatcher.dispatch().taskEnd(task,Option<Exception>.None)
                }
                return true
            }

            if(let Some(i) = fileBusyList){
                if(i.size>0){
                    println("fileBusyListSize="+i.size.toString())
                }
            }
        }
        return false
    }



    private func processCalls():Unit{
        synchronized(m){
            if (skipProceedCallCount.load() > 0){
                return
            }
            if (runningAsyncSize() >= maxParallelRunningCount){
                return
            }
            if (readyAsyncCalls.isEmpty()){
                return
            }
            let TempreadyAsyncCalls:ArrayList<DownloadCall> = ArrayList<DownloadCall>()
            for(call in readyAsyncCalls){
                TempreadyAsyncCalls.append(call)
            }

            for(call in TempreadyAsyncCalls){
                let task:DownloadTask = call.task

                readyAsyncCalls.removeIf({mycall:DownloadCall =>
                    let myTask:DownloadTask = mycall.task
                    let b = refEq(myTask,task)
                    return b
                })

                runningAsyncCalls.append(call)
                spawn{=>
                    try{
                        call.executeCall()
                    }finally{
                        finish(call)
                    }
                }
                if (runningAsyncSize() >= maxParallelRunningCount){
                    return
                }
            }
        }
    }

    private func runningAsyncSize():Int64{
        return runningAsyncCalls.size - flyingCanceledAsyncCallCount.load()
    }
}
