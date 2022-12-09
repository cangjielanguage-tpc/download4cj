package okdownload

public interface DownloadConnectionFactory {

    func create(url:String):DownloadConnection

}
