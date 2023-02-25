package okdownload

from std import regex.*

public class DownloadStrategy{

    private static let TAG:String = "DownloadStrategy"

    let m:MultiConditionMonitor = MultiConditionMonitor()


    // 1 connection: [0, 1MB)
    private static let ONE_CONNECTION_UPPER_LIMITA:Int64 = 1*1024*1024    //1
    // 2 connection: [1MB, 5MB)
    private static let TWO_CONNECTION_UPPER_LIMITA:Int64 = 5*1024*1024    //5
    // 3 connection: [5MB, 50MB)
    private static let THREE_CONNECTION_UPPER_LIMITA:Int64 = 50*1024*1024   //50
    // 4 connection: [50MB, 100MB)
    private static let FOUR_CONNECTION_UPPER_LIMITA:Int64 = 100*1024*1024   //100


     func resumeAvailableResponseCheck(connected:DownloadConnectionConnected,blockIndex:Int64,info:BreakpointInfo):ResumeAvailableResponseCheck{
        return ResumeAvailableResponseCheck(connected, blockIndex, info)
    }


     func determineBlockCount(task:DownloadTask,totalLengtha:Int64):Int64{
        if(let Some(i) = task.getSetConnectionCount()){
            if(i != 0){
                return i
            }
        }
        if (totalLengtha < ONE_CONNECTION_UPPER_LIMITA) {
            return 1
        }
        if (totalLengtha < TWO_CONNECTION_UPPER_LIMITA) {
            return 2
        }
        if (totalLengtha < THREE_CONNECTION_UPPER_LIMITA) {
            return 3
        }
        if (totalLengtha < FOUR_CONNECTION_UPPER_LIMITA) {
            return 4
        }
        return 5
    }




     func inspectAnotherSameInfo(task:DownloadTask,info:BreakpointInfo,instanceLength:Int64):Bool{
        if (!task.isFilenameFromResponse()){
            return false
        }

        let store:BreakpointStore = OkDownload.withs().breakpointStore()

        let anotherInfo:Option<BreakpointInfo> = store.findAnotherInfoFromCompare(task, info)

        if(let Some(i) = anotherInfo){
        }else{
            return false
        }

         if (anotherInfo.getOrThrow().getTotalLength() != instanceLength) {
            return false
        }

        return true
    }


     func isUseMultiBlock(isAcceptRange:Bool){
        // output stream not support seek
        if (!OkDownload.withs().outputStreamFactory().supportSeek()){
            return false
        }
         //  support range
        return isAcceptRange
    }

    private static let TMP_FILE_NAME_PATTERN:Regex = Regex(".*\\\\|/([^\\\\|/|?]*)\\??")


     func validFilenameFromResponse(responseFileName:String,task:DownloadTask):Unit{
        if(Util.isEmpty(task.getFilename())){
            if(Util.isEmpty(responseFileName)){
                  var filename = ""
                  try{
                     let lastIndex:Int64 = task.getUrl().lastIndexOf("/").getOrThrow()
                     filename = task.getUrl().substring(lastIndex+1)
                  }catch(e:Exception){
                     println(e.toString())
                  }

                 if(Util.isEmpty(filename)){
                    filename = Time.now().unixTimeStamp().nanoseconds().toString()
                 }

                  task.filenameHolder = FileNameHolder(filename)
                  task.targetFile = task.getParentFile().createFile(filename)
                  task.providedPathFile = task.getFile().getOrThrow()
            }else{
                //不为空 这个就是文件名
                task.filenameHolder = FileNameHolder(responseFileName)
                task.targetFile = task.getParentFile().createFile(responseFileName)
                task.providedPathFile = task.getFile().getOrThrow()
            }
        }
    }












     func getPreconditionFailedCause(responseCode:Int64,isAlreadyProceed:Bool,info:BreakpointInfo,responseEtag:String):Option<ResumeFailedCause>{
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
        return Option<ResumeFailedCause>.None

    }

     func isServerCanceled(responseCode:Int64,isAlreadyProceed:Bool):Bool{
        if (responseCode != Util.HTTP_PARTIAL && responseCode != Util.HTTP_OK) {
            return true
        }

        if (responseCode == Util.HTTP_OK && isAlreadyProceed) {
            return true
        }

        return false
    }

}
