package okdownload

public class  BreakpointRemoteCheck {

    private var acceptRange:Bool
    private var resumable:Bool
    var failedCause:Option<ResumeFailedCause>
    private var instanceLength:Int64

    private let task:DownloadTask
    private let info:BreakpointInfo

     init(task:DownloadTask,info:BreakpointInfo){
        this.task = task
        this.info = info
        this.acceptRange = false
        this.resumable = false
        this.failedCause = Option<ResumeFailedCause>.None
        this.instanceLength = 0
    }


     func toString():String{
        return "acceptRange[" + acceptRange.toString() + "] resumable[" + resumable.toString() + "] failedCause[failedCause.getOrThrow().toString()instanceLength[" + instanceLength.toString() + "]"
    }





     func getCauseOrThrow():ResumeFailedCause{
        return this.failedCause.getOrThrow()
    }

     func isResumable():Bool{
        return resumable
    }

     func isAcceptRange():Bool{
        return acceptRange
    }

     func getInstanceLength():Int64{
        return instanceLength
    }


     func check():Unit{
        let downloadStrategy:DownloadStrategy = OkDownload.withs().downloadStrategy()
        var connectTrial:ConnectTrial = createConnectTrial()
        connectTrial.executeTrial()
         let isAcceptRange:Bool = connectTrial.isAcceptRange()
         let isChunked:Bool = connectTrial.isChunked()

         let instanceLength:Int64 = connectTrial.getInstanceLength()
         let responseEtag:String = connectTrial.getResponseEtag()
         let responseFilename:String =  connectTrial.getResponseFilename()
         let responseCode:Int64 =  connectTrial.getResponseCode()

         downloadStrategy.validFilenameFromResponse(responseFilename, task)
         info.setChunked(isChunked)
         info.setEtag(responseEtag)

         let resumeFailedCause:Option<ResumeFailedCause> = downloadStrategy.getPreconditionFailedCause(responseCode, info.getTotalOffset() != 0, info,responseEtag)

         if(let Some(i) = resumeFailedCause){
             this.resumable = false
         }else{
             this.resumable = true
         }
         this.failedCause = resumeFailedCause
         this.instanceLength = instanceLength
         this.acceptRange = isAcceptRange


          if (!isTrialSpecialPass(responseCode, instanceLength, resumable)) {
            if(downloadStrategy.isServerCanceled(responseCode, info.getTotalOffset() != 0)){
                throw ServerCanceledException(responseCode, info.getTotalOffset())
            }
         }
    }



    func isTrialSpecialPass(responseCode:Int64,instanceLength:Int64,isResumable:Bool):Bool{
        if (responseCode == Util.RANGE_NOT_SATISFIABLE && instanceLength >= 0 && isResumable) {
            // provide valid instance-length & resumable but backend response wrong code 416
            // for the range:0-0, because of values on response header is valid we pass it.
            return true
        }
        return false
    }


    func createConnectTrial():ConnectTrial{
        return ConnectTrial(task,info)
    }

}
