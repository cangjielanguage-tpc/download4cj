package download4cj

public class ResumeAvailableResponseCheck {

    private var connected:DownloadConnectionConnected
    private var info:BreakpointInfo
    private var blockIndex:Int64

    init(connected:DownloadConnectionConnected,blockIndex:Int64,info:BreakpointInfo){
        this.connected = connected
        this.info = info
        this.blockIndex = blockIndex
    }

     func inspect():Unit{
        let blockInfo:BlockInfo = info.getBlock(blockIndex).getOrThrow()
        let code:Int64 = connected.getResponseCode()
        var newEtag:Option<String> = connected.getResponseHeaderField(Util.ETAG)
        if(let Some(_) <- newEtag){
        }else{
            newEtag = ""
        }
        Download4cj.withs().downloadStrategy().getPreconditionFailedCause(code, blockInfo.getCurrentOffset() != 0,info,newEtag.getOrThrow())
        let isServerCancelled:Bool =  Download4cj.withs().downloadStrategy().isServerCanceled(code, blockInfo.getCurrentOffset() != 0)
        if (isServerCancelled) {
            throw ServerCanceledException(code, blockInfo.getCurrentOffset())
        }
    }

}
