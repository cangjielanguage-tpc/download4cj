package okdownload

public class DownloadUriOutputStream <: DownloadOutputStream{


    let out:BufferedOutputStream
    let fos:File

    init(uri:String,bufferSize:Int64){
        this.fos = File(uri,OpenOption.Open(true,true))
        this.out = BufferedOutputStream(fos,bufferSize)
    }


    public func write(b:Array<UInt8>,off:Int64,len:Int64){
        out.write(b)
    }


    public func close():Unit{
        fos.close()
    }

    public func flushAndSync():Unit{
        out.flush()
        fos.flush()
    }


    public func seek(offset:Int64):Unit{
        fos.seek(SeekPosition.Current(offset))
    }


    public func setLength(newLength:Int64):Unit{
        //空实现
    }

}
