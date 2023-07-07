package okdownload

public class ProcessFileStrategy {


    private let fileLock:FileLock = FileLock()

     func createProcessStream(task:DownloadTask,info:BreakpointInfo,store:DownloadStore):MultiPointOutputStream{
        return MultiPointOutputStream(task,info,store)
    }



     func discardProcess(task:DownloadTask):Unit{
        let file:Option<File> = task.getFile()
        if(let Some(_) = file){
        }else{
            return
        }

        if(File.exists(file.getOrThrow().info.path)){
            try{
                if(!file.getOrThrow().isClosed()){
                    file.getOrThrow().close()
                }
                File.delete(file.getOrThrow().info.path)
            }catch(e:Exception){
                throw ReadWriteException("Delete file failed!")
            }
        }
    }




     func isPreAllocateLength(task:DownloadTask):Bool{
        var supportSeek:Bool = OkDownload.withs().outputStreamFactory().supportSeek()
        if(!supportSeek){
            return false
        }
        if(let Some(i) = task.getSetPreAllocateLength()){
            return i
        }else{
            return true
        }


    }
}
