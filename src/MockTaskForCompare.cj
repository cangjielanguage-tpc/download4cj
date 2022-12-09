package okdownload

public class MockTaskForCompare <: IdentifiedTask {

    let id:Int64
    let url:String
    let providedPathFile:Option<File>
    let filename:String
    let parentFile:Option<Directory>


    //------


    public init(id:Int64,task:DownloadTask) {
        this.id = id
        this.url =  task.getUrl()
        this.parentFile = task.getParentFile()
        this.providedPathFile = task.getProvidedPathFile()
        this.filename = task.getFilename().getOrThrow()
    }


    public func getId():Int64{
        return id
    }



    public func getUrl():String{
        return url
    }


    public func getProvidedPathFile():File{
        return providedPathFile.getOrThrow()
    }


    public func getParentFile():Directory{
        return parentFile.getOrThrow()
    }


    public func getFilename():Option<String>{
        return filename
    }

}
