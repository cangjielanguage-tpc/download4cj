

from std import socket.*
from net import tls.*
from std import collection.*
from std import time.*
from std import sync.*

//https://cdn.llscdn.com/yy/files/xs8qmxn8-lls-LLS-5.8-800-20171207-111607.apk
//https://www.voidtools.com/Everything-1.4.1.1017.x64-Setup.exe

//1,862,488  0-1862487
//0-931243
//931244-1862487
main() {
    let str = """
GET /Everything-1.4.1.1017.x64-Setup.exe HTTP/1.1
User-Agent: OkDownload/1.0.7
Range: bytes=0-0
Keep-Alive: timeout=600, max=1000
Host: www.voidtools.com
Connection: Keep-Alive

"""

    var cfg = TlsClientConfig("")
    cfg.verifyMode = VerifyNone
    let arr = Array<UInt8>(409600,item:0)

    let s1 = TlsSocket(TCP,"www.voidtools.com",443,cfg)
    s1.connect()
    s1.write(str.toUtf8Array())
    let readlen = s1.read(arr)
    s1.close()
    let res = String.fromUtf8(arr[0..readlen])
    println("---${readlen}")
    println("<---\n${res}\n--->")
    if(readlen>0){
        println(true)
    }

    if(readlen<4096){
        println(true)
    }

    let f1 = spawn{
        down1()
    }


    let f2 = spawn{
        down2()
    }


    f1.get()
    f2.get()
    return 0
}


func down1():Unit{
            let str2 = """
GET /Everything-1.4.1.1017.x64-Setup.exe HTTP/1.1
User-Agent: OkDownload/1.0.7
Range: bytes=0-931243
Keep-Alive: timeout=600, max=1000
Host: www.voidtools.com
Connection: Keep-Alive

"""
         var cfg = TlsClientConfig("")
            cfg.verifyMode = VerifyNone
            let s2 = TlsSocket(TCP,"www.voidtools.com",443,cfg)
            let arr2 = Array<UInt8>(409600,item:0)
            s2.connect()
            s2.write(str2.toUtf8Array())
            var len2=0
            while(len2 < 931244){

                //try{
                     len2 += s2.read(arr2, Duration.hour*1)
                // }catch(e:Exception){
                //      let isClosed = s2.isClosed()
                //     print("-----------------------------------isClosed="+isClosed.toString()+"-----------------------------len="+len2.toString())
                // }
            }
            s2.close()
            println("s2 done")

}

func down2():Unit{
            let str3 = """
GET /Everything-1.4.1.1017.x64-Setup.exe HTTP/1.1
User-Agent: OkDownload/1.0.7
Range: bytes=931244-1862487
Keep-Alive: timeout=600, max=1000
Host: www.voidtools.com
Connection: Keep-Alive

"""
            var cfg = TlsClientConfig("")
            cfg.verifyMode = VerifyNone
            let s3 = TlsSocket(TCP,"www.voidtools.com",443,cfg)
            let arr3 = Array<UInt8>(409600,item:0)
            s3.connect()
            s3.write(str3.toUtf8Array())
            var len3=0
            while(len3 < 931244){
                // try{
                     len3 += s3.read(arr3, Duration.hour*1)
                // }catch(e:Exception){
                //      let isClosed = s3.isClosed()
                //     print("-----------------------------------isClosed="+isClosed.toString()+"-----------------------------len="+len3.toString())
                // }
            }
            s3.close()
            println("s3 done")
}


