package okdownload

public class ResumeAvailableResponseCheck {

    private var connected:DownloadConnectionConnected
    private var info:BreakpointInfo
    private var blockIndex:Int64

    init(connected:DownloadConnectionConnected,blockIndex:Int64,info:BreakpointInfo){
        this.connected = connected
        this.info = info
        this.blockIndex = blockIndex
    }

    public func inspect():Unit{
        let blockInfo:BlockInfo = info.getBlock(blockIndex).getOrThrow()
        let code:Int64 = connected.getResponseCode()
        let newEtag:String = connected.getResponseHeaderField("Etag").getOrThrow()
        let resumeFailedCause:Option<ResumeFailedCause> = OkDownload.withs().downloadStrategy().getPreconditionFailedCause(code, blockInfo.getCurrentOffset() != 0,info,newEtag)
        //------

        let isServerCancelled:Bool =  OkDownload.withs().downloadStrategy().isServerCanceled(code, blockInfo.getCurrentOffset() != 0)
        if (isServerCancelled) {
            // server cancelled, end task.
            //throw ServerCanceledException(code, blockInfo.getCurrentOffset())
        }
    }

}
