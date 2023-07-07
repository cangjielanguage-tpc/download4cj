package okdownload

public class CallbackDispatcher {

   private static let TAG:String = "CallbackDispatcher"

   private let transmit:DownloadListener

   init(){
      this.transmit = DefaultTransmitListener()
   }

   func isFetchProcessMoment(task:DownloadTask):Bool{
        let minInterval:Int64 = task.getMinIntervalMillisCallbackProcess()


        let now:Int64 = DateTime.now().toUnixTimeStamp().toNanoseconds()

        return (minInterval <= 0) || ((now - TaskHideWrapper.getLastCallbackProcessTs(task)) >= minInterval)
   }

   func endTasks(completedTaskCollection:ArrayList<DownloadTask>,sameTaskConflictCollection:ArrayList<DownloadTask>,fileBusyCollection:ArrayList<DownloadTask>){

      if (completedTaskCollection.size == 0 && sameTaskConflictCollection.size == 0&& fileBusyCollection.size == 0) {
            return
      }

      for (task in completedTaskCollection) {
         task.getListener().taskEnd(task, Option<Exception>.None)
      }
      for (task in sameTaskConflictCollection) {
         task.getListener().taskEnd(task, Option<Exception>.None)
      }
      for (task in fileBusyCollection) {
         task.getListener().taskEnd(task, Option<Exception>.None)
      }

   }

   func endTasksWithCanceled(canceledCollection:ArrayList<DownloadTask>):Unit{
       if (canceledCollection.size <= 0){
         return
       }
       for (task in canceledCollection) {
         task.getListener().taskEnd(task, Option<Exception>.None)
       }
   }

   func dispatch():DownloadListener{
        return transmit
   }
}
