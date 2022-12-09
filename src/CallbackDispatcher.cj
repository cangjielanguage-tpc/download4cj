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

//------



//------




//......

   public func dispatch():DownloadListener{
        return transmit
   }
}
