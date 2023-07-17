package download4cj

public interface DownloadConnectionFactory {

    func create(url:String):DownloadConnection

}
