package okdownload

public interface DownloadConnection {


    func addHeader(name:String,value:String):Unit

    func setRequestMethod(method:String):Bool

    func execute():DownloadConnectionConnected

    func release():Unit

    func getRequestProperties():HashMap<String,ArrayList<String>>

    func getRequestProperty(key:String):String

}
