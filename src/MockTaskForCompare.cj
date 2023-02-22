package okdownload

public class MockTaskForCompare <: IdentifiedTask {

    let id:Int64
    let url:String
    let providedPathFile:Option<File>
    let filename:String
    let parentFile:Option<Directory>




     init(id:Int64,task:DownloadTask) {
        this.id = id
        this.url =  task.getUrl()
        this.parentFile = task.getParentFile()
        this.providedPathFile = task.getProvidedPathFile()
        if(Util.isEmpty(task.getFilename())){
            this.filename = ""
        }else{
            this.filename = task.getFilename().getOrThrow()
        }
    }


     func getId():Int64{
        return id
    }



     func getUrl():String{
        return url
    }


     func getProvidedPathFile():Option<File>{
        return providedPathFile.getOrThrow()
    }


     func getParentFile():Directory{
        return parentFile.getOrThrow()
    }


     func getFilename():Option<String>{
        return filename
    }

}
