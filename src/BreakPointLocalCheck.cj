package okdownload

public class BreakpointLocalCheck {

    private var dirty:Bool
    var fileExist:Bool
    var infoRight:Bool
    var outputStreamSupport:Bool

    private let task:DownloadTask
    private let info:BreakpointInfo
    private let responseInstanceLength:Int64

    public init(task:DownloadTask,info:BreakpointInfo,responseInstanceLength:Int64){
        this.task = task
        this.info = info
        this.responseInstanceLength = responseInstanceLength
        dirty = false
        fileExist = false
        infoRight = false
        outputStreamSupport = false
    }


    public func isDirty():Bool{
        return dirty
    }

    public func getCauseOrThrow():ResumeFailedCause{
        if (!infoRight) {
            return INFO_DIRTY
        }

        //------

        throw IllegalStateException("No cause find with dirty: " + dirty.toString())
    }

    public func isInfoRightToResume():Bool{

        let blockCount:Int64 = info.getBlockCount()
        if(blockCount <= 0){
            return false
        }

        //......


        return true
    }


    public func isOutputStreamSupportResume():Bool{

        //------TODO
        //let supportSeek:Bool = OkDownload.withs().outputStreamFactory().supportSeek()
        let supportSeek:Bool = true
        if (supportSeek){
             return true
        }

        //------


        return true
    }


    public func isFileExistToResume():Bool{
        let uri:URL = task.getUri()
        let file:Option<File> = task.getFile()
        if(let Some(i) = file){

        }else{
            return false
        }

        if(File.exists(file.getOrThrow().info.path)){
            return true
        }else{
            return false
        }
    }


    public func check():Unit{
        fileExist = isFileExistToResume()
        infoRight = isInfoRightToResume()
        outputStreamSupport = isOutputStreamSupportResume()
        println(fileExist.toString()+"--"+infoRight.toString()+"--"+outputStreamSupport.toString())
        dirty = !infoRight || !fileExist || !outputStreamSupport
    }



    public func toString():String{
         return "fileExist[" + fileExist.toString() + "] infoRight[" + infoRight.toString() + "] outputStreamSupport[" + outputStreamSupport.toString() + "]"
    }
}
