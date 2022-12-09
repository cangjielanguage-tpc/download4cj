package okdownload

public interface DownloadOutputStream {

    func write(b:Array<UInt8> , off:Int64 , len:Int64):Unit

    func close():Unit

    func flushAndSync():Unit

    func seek(offset:Int64):Unit

    func setLength(newLength:Int64):Unit

}
