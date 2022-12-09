package okdownload

public interface DownloadOutputStreamFactory {

    func create(file:File,flushBufferSize:Int64):DownloadOutputStream

    func create(uri:URL,flushBufferSize:Int64):DownloadOutputStream

    func supportSeek():Bool

}
