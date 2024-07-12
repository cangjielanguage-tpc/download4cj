/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights resvered.
 */

package download4cj

public class BreakpointLocalCheck {

    private var dirty:Bool
    var fileExist:Bool
    var infoRight:Bool
    var outputStreamSupport:Bool

    private let task:DownloadTask
    private let info:BreakpointInfo
    private let responseInstanceLength:Int64

    init(task:DownloadTask,info:BreakpointInfo,responseInstanceLength:Int64){
        this.task = task
        this.info = info
        this.responseInstanceLength = responseInstanceLength
        dirty = false
        fileExist = false
        infoRight = false
        outputStreamSupport = false
    }

    func isDirty():Bool{
        return dirty
    }


    func isInfoRightToResume():Bool{
        let blockCount:Int64 = info.getBlockCount()
        if(blockCount <= 0){
            return false
        }
        return true
    }

    func isOutputStreamSupportResume():Bool{
        let supportSeek:Bool = Download4cj.withs().outputStreamFactory().supportSeek()
        if (supportSeek){
             return true
        }
        return true
    }

    func isFileExistToResume():Bool{
        let file:Option<File> = task.getFile()
        if(let Some(_) <- file){
        }else{
            return false
        }
        if(File.exists(file.getOrThrow().info.path)){
            return true
        }else{
            return false
        }
    }

    func check():Unit{
        fileExist = isFileExistToResume()
        infoRight = isInfoRightToResume()
        outputStreamSupport = isOutputStreamSupportResume()
        dirty = !infoRight || !fileExist || !outputStreamSupport
    }

    func toString():String{
         return "fileExist[" + fileExist.toString() + "] infoRight[" + infoRight.toString() + "] outputStreamSupport[" + outputStreamSupport.toString() + "]"
    }
}
