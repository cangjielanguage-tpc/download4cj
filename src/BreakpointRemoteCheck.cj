package okdownload

public class  BreakpointRemoteCheck {

    private var acceptRange:Bool
    private var resumable:Bool
    var failedCause:Option<ResumeFailedCause>
    private var instanceLength:Int64

    private let task:DownloadTask
    private let info:BreakpointInfo

    public init(task:DownloadTask,info:BreakpointInfo){
        this.task = task
        this.info = info
        this.acceptRange = false
        this.resumable = false
        this.failedCause = Option<ResumeFailedCause>.None
        this.instanceLength = 0
    }


    public func toString():String{
        return "acceptRange[" + acceptRange.toString() + "] resumable[" + resumable.toString() + "] failedCause[failedCause.getOrThrow().toString()instanceLength[" + instanceLength.toString() + "]"
    }


    //------




    public func getCauseOrThrow():ResumeFailedCause{
        //------

        return this.failedCause.getOrThrow()
    }

    public func isResumable():Bool{
        return resumable
    }

    public func isAcceptRange():Bool{
        return acceptRange
    }

    public func getInstanceLength():Int64{
        return instanceLength
    }


    public func check():Unit{
        println("mmmmmmm11")
        let downloadStrategy:DownloadStrategy = OkDownload.withs().downloadStrategy()
        println("mmmmmmm12")



        var connectTrial:ConnectTrial = createConnectTrial()

        println("mmmmmmm13")


        connectTrial.executeTrial()



         let isAcceptRange:Bool = connectTrial.isAcceptRange()
         println("mmmmmmm27"+isAcceptRange.toString())
         let isChunked:Bool = connectTrial.isChunked()
         println("mmmmmmm28"+isChunked.toString())

         let instanceLength:Int64 = connectTrial.getInstanceLength()
        println("mmmmmmm29"+instanceLength.toString())
         let responseEtag:String = connectTrial.getResponseEtag()
        println("mmmmmmm30"+responseEtag.toString())
         let responseFilename:String =  connectTrial.getResponseFilename()
        println("mmmmmmm31"+responseFilename.toString())
         let responseCode:Int64 =  connectTrial.getResponseCode()
        println("mmmmmmm32"+responseCode.toString())

         downloadStrategy.validFilenameFromResponse(responseFilename, task, info)
         info.setChunked(isChunked)
         info.setEtag(responseEtag)

         if (OkDownload.withs().downloadDispatcher().isFileConflictAfterRun(task)) {
             throw FileBusyAfterRunException.SIGNAL
         }
         println("mmmmmmm33")
         let resumeFailedCause:Option<ResumeFailedCause> = downloadStrategy.getPreconditionFailedCause(responseCode, info.getTotalOffset() != 0, info,responseEtag)

         if(let Some(i) = resumeFailedCause){
             this.resumable = false
         }else{
             this.resumable = true
         }
         this.failedCause = resumeFailedCause
         this.instanceLength = instanceLength
         this.acceptRange = isAcceptRange

          println("mmmmmmm36----")

          if (!isTrialSpecialPass(responseCode, instanceLength, resumable) && downloadStrategy.isServerCanceled(responseCode, info.getTotalOffset() != 0)) {
             throw ServerCanceledException(responseCode, info.getTotalOffset())
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
