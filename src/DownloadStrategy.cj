package okdownload

from std import regex.*

public class DownloadStrategy{

    private static let TAG:String = "DownloadStrategy"

    let m:MultiConditionMonitor = MultiConditionMonitor()


    // 1 connection: [0, 1MB)
    private static let ONE_CONNECTION_UPPER_LIMIT:Int64 = 1*1024*1024    //1
    // 2 connection: [1MB, 5MB)
    private static let TWO_CONNECTION_UPPER_LIMIT:Int64 = 5*1024*1024    //5
    // 3 connection: [5MB, 50MB)
    private static let THREE_CONNECTION_UPPER_LIMIT:Int64 = 50*1024*1024   //50
    // 4 connection: [50MB, 100MB)
    private static let FOUR_CONNECTION_UPPER_LIMIT:Int64 = 100*1024*1024   //100


    public func resumeAvailableResponseCheck(connected:DownloadConnectionConnected,blockIndex:Int64,info:BreakpointInfo):ResumeAvailableResponseCheck{
        return ResumeAvailableResponseCheck(connected, blockIndex, info)
    }


    public func determineBlockCount(task:DownloadTask,totalLength:Int64):Int64{
        println("conn1")
        if(let Some(i) = task.getSetConnectionCount()){
            if(i != 0){
                return i
            }
        }else{

        }
        println("conn3")
        if (totalLength < ONE_CONNECTION_UPPER_LIMIT) {
            return 1
        }

        if (totalLength < TWO_CONNECTION_UPPER_LIMIT) {
            return 2
        }

        if (totalLength < THREE_CONNECTION_UPPER_LIMIT) {
            return 3
        }

        if (totalLength < FOUR_CONNECTION_UPPER_LIMIT) {
            return 4
        }

        return 5
    }

    //------



    public func inspectAnotherSameInfo(task:DownloadTask,info:BreakpointInfo,instanceLength:Int64):Bool{
        println("lllll2")
        if (!task.isFilenameFromResponse()){
            return false
        }
        println("lllll3")

        let store:BreakpointStore = OkDownload.withs().breakpointStore()
        println("lllll4")

        let anotherInfo:Option<BreakpointInfo> = store.findAnotherInfoFromCompare(task, info)
        println("lllll5")

        if(let Some(i) = anotherInfo){
            //------

        }else{
             println("lllll8")
            return false
        }
        //------

        return true
    }


    public func isUseMultiBlock(isAcceptRange:Bool){
        // output stream not support seek
        if (!OkDownload.withs().outputStreamFactory().supportSeek()){
            return false
        }
         //  support range
        return isAcceptRange
    }

    private static let TMP_FILE_NAME_PATTERN:Regex = Regex(".*\\\\|/([^\\\\|/|?]*)\\??")


    //------


    public func validFilenameFromResponse(responseFileName:String,task:DownloadTask,info:BreakpointInfo):Unit{
        if(Util.isEmpty(task.getFilename())){
            //------

        }
    }



    //......




   //......




    public func validInfoOnCompleted(task:DownloadTask,store:DownloadStore):Unit{
        //------

    }

    public func getPreconditionFailedCause(responseCode:Int64,isAlreadyProceed:Bool,info:BreakpointInfo,responseEtag:String):Option<ResumeFailedCause>{
        let localEtag:String = info.getEtag().getOrThrow()
        if(responseCode == Util.HTTP_PRECON_FAILED){
            return RESPONSE_PRECONDITION_FAILED
        }

        if (!Util.isEmpty(localEtag) && !Util.isEmpty(responseEtag) && !responseEtag.equals(localEtag)) {
            // etag changed.
            // also etag changed is relate to HTTP_PRECON_FAILED
            return RESPONSE_ETAG_CHANGED
        }

        if (responseCode == Util.HTTP_CREATED && isAlreadyProceed) {
        // The request has been fulfilled and has resulted in one or more new resources
        // being created.
        // mark this case is precondition failed for
        // 1. checkout whether accept partial
        // 2. 201 means new resources so range must be from beginning otherwise it can't
        // match local range.
            return RESPONSE_CREATED_RANGE_NOT_FROM_0
        }

        if (responseCode == Util.HTTP_RESET && isAlreadyProceed) {
            return RESPONSE_RESET_RANGE_NOT_FROM_0
        }
        println("mmmmmmmm35b")
        return Option<ResumeFailedCause>.None

    }

    public func isServerCanceled(responseCode:Int64,isAlreadyProceed:Bool):Bool{
        if (responseCode != Util.HTTP_PARTIAL && responseCode != Util.HTTP_OK) {
            return true
        }

        if (responseCode == Util.HTTP_OK && isAlreadyProceed) {
            return true
        }

        return false
    }

}
