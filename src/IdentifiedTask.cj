package okdownload

public abstract class IdentifiedTask{

    static public let EMPTY_URL: String = ""
    static public let EMPTY_FILEPATH : String = "" //文件路径为空

    public func getId(): Int64

    public func getUrl(): String

    protected func getProvidedPathFile():Option<File>

    public func getParentFile():Directory

    public func getFilename():Option<String>


    public func compareIgnoreId(another : IdentifiedTask):Bool{
        //------

        return true
    }
}
