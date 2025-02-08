/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights resvered.
 */

package download4cj

public class DownloadUriOutputStream <: DownloadOutputStream{


    let out:BufferedOutputStream<OutputStream>
    let fos:File

    init(uri:String,bufferSize:Int64){
        this.fos = File(uri,OpenMode.ReadWrite)
        this.out = BufferedOutputStream(fos,bufferSize)
    }


    public func write(b:Array<UInt8>):Unit{
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
        newLength.toString()
    }

}
