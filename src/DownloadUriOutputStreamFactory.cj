package okdownload

public class DownloadUriOutputStreamFactory <: DownloadOutputStreamFactory{



    public func create(file:File,flushBufferSize:Int64):DownloadOutputStream{
        return  DownloadUriOutputStream(URL.parse(file.info.path.toString()), flushBufferSize)
    }


    public func create(url:URL,flushBufferSize:Int64):DownloadOutputStream{
        return  DownloadUriOutputStream(url, flushBufferSize)
    }


    public func supportSeek():Bool{
        return true
    }
}
