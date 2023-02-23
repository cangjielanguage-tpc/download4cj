package okdownload

public abstract class IdentifiedTask{

    static  let EMPTY_URL: String = ""
    static  let EMPTY_FILEPATH : String = "" //文件路径为空

     func getId(): Int64

     func getUrl(): String

    protected func getProvidedPathFile():Option<File>

     func getParentFile():Directory

     func getFilename():Option<String>


     func compareIgnoreId(another : IdentifiedTask):Bool{

        return true
    }
}
