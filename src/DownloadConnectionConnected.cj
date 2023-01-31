package okdownload

public interface DownloadConnectionConnected {

    func getResponseCode():Int64

    func getInputStream():Source

    func getResponseHeaderFields():Option<HashMap<String,ArrayList<String>>>

    func getResponseHeaderField(name:String):Option<String>

    func getRedirectLocation():Option<String>

}
