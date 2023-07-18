package download4cj

public class DownloadUriOutputStreamFactory <: DownloadOutputStreamFactory{



    public func create(file:File,flushBufferSize:Int64):DownloadOutputStream{
        return  DownloadUriOutputStream(file.info.path.toString(), flushBufferSize)
    }


    public func create(url:String,flushBufferSize:Int64):DownloadOutputStream{
        return  DownloadUriOutputStream(url, flushBufferSize)
    }


    public func supportSeek():Bool{
        return true
    }
}
