package okdownload

public interface DownloadConnection {

    //prop var NO_RESPONSE_CODE:Int64

    func addHeader(name:String,value:String):Unit

    func setRequestMethod(method:String):Bool

    func execute():DownloadConnectionConnected

    func release():Unit

    func getRequestProperties():HashMap<String,ArrayList<String>>

    func getRequestProperty(key:String):String

}
