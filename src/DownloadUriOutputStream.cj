package okdownload

public class DownloadUriOutputStream <: DownloadOutputStream{


    let out:BufferedOutputStream
    let fos:File

    public init(uri:URL,bufferSize:Int64){
        this.fos = File(uri.toString(),OpenOption.Open(true,true))
        this.out = BufferedOutputStream(fos,bufferSize)
    }


    public func write(b:Array<UInt8>,off:Int64,len:Int64){
        //println("再往文件里write   len= "+ len.toString()+" off="+off.toString()+" Array<UInt8>="+b.size.toString())
        out.write(b)
    }


    public func close():Unit{
        //println("close了")
        fos.close()
    }

    public func flushAndSync():Unit{
        //println("flush了")
        out.flush()
        fos.flush()
    }


    public func seek(offset:Int64):Unit{
        fos.seek(SeekPosition.Current(offset))
    }


    public func setLength(newLength:Int64):Unit{

    }

}
