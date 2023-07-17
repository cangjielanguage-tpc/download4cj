package download4cj

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


    protected func getId():Int64{
        return id
    }



    protected func getUrl():String{
        return url
    }


    protected func getProvidedPathFile():Option<File>{
        return providedPathFile.getOrThrow()
    }


    protected  func getParentFile():Directory{
        return parentFile.getOrThrow()
    }


    protected func getFilename():Option<String>{
        return filename
    }

}
