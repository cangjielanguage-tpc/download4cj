package okdownload

public class CallbackDispatcher {

   private static let TAG:String = "CallbackDispatcher"

   private let transmit:DownloadListener

//------


   public init(){
      this.transmit = DefaultTransmitListener()
   }

   public func isFetchProcessMoment(task:DownloadTask):Bool{
        let minInterval:Int64 = task.getMinIntervalMillisCallbackProcess()


        let now:Int64 = Time.now().unixNano()/1000

        return (minInterval <= 0) || ((now - TaskHideWrapper.getLastCallbackProcessTs(task)) >= minInterval)
   }


   public func endTasksWithError(errorCollection:ArrayList<DownloadTask>,realCause:Exception):Unit{
      if(errorCollection.size <= 0){
         return
      }

      for (task in errorCollection) {
         //task.getListener().taskEnd(task, EndCause.ERROR, realCause)
         task.getListener().taskEnd(task, realCause)
      }
   }


   public func endTasks(completedTaskCollection:ArrayList<DownloadTask>,sameTaskConflictCollection:ArrayList<DownloadTask>,fileBusyCollection:ArrayList<DownloadTask>){

      if (completedTaskCollection.size == 0 && sameTaskConflictCollection.size == 0&& fileBusyCollection.size == 0) {
            return
      }

      for (task in completedTaskCollection) {
         //task.getListener().taskEnd(task, EndCause.COMPLETED, Option<Exception>.None)
         task.getListener().taskEnd(task, Option<Exception>.None)
      }
      for (task in sameTaskConflictCollection) {
         //task.getListener().taskEnd(task, EndCause.SAME_TASK_BUSY, Option<Exception>.None)
         task.getListener().taskEnd(task, Option<Exception>.None)
      }
      for (task in fileBusyCollection) {
         //task.getListener().taskEnd(task, EndCause.FILE_BUSY, Option<Exception>.None)
         task.getListener().taskEnd(task, Option<Exception>.None)
      }

   }



//------




//......

   public func dispatch():DownloadListener{
        return transmit
   }
}
