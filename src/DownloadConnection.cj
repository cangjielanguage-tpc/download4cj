package download4cj

public interface DownloadConnection {

    func addHeader(name:String,value:String):Unit

    func execute():DownloadConnectionConnected

    func release():Unit

    func getRequestProperties():HashMap<String,ArrayList<String>>

}
