package okdownload

public class ProcessFileStrategy {


    private let fileLock:FileLock = FileLock()

    public func createProcessStream(task:DownloadTask,info:BreakpointInfo,store:DownloadStore):MultiPointOutputStream{
        return MultiPointOutputStream(task,info,store)
    }

    //------


    public func discardProcess(task:DownloadTask):Unit{
        let file:Option<File> = task.getFile()
        if(let Some(i) = file){

        }else{
            return
        }

        if(File.exists(file.getOrThrow().info.path)){
            try{
                File.delete(file.getOrThrow().info.path)
                println("delete success")
            }catch(e:Exception){
                throw IOException("Delete file failed!")
            }
        }
    }

    //------



    public func isPreAllocateLength(task:DownloadTask):Bool{
        println("isPreAllocateLengthisPreAllocateLength0")
        var supportSeek:Bool = OkDownload.withs().outputStreamFactory().supportSeek()
        if(!supportSeek){
            return false
        }
        println("isPreAllocateLengthisPreAllocateLength11")
        if(let Some(i) = task.getSetPreAllocateLength()){
            //println("isPreAllocateLengthisPreAllocateLength12")
            return i
        }else{
            println("isPreAllocateLengthisPreAllocateLength13")
            return true
        }


    }
}
