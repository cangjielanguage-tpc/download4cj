

from std import socket.*
from net import tls.*
from std import collection.*
from std import time.*
from std import sync.*


main(){
    //for(_ in 0..20){
        maintest1()
    //}
}

public func maintest1() {
    let str = """
GET /yy/files/xs8qmxn8-lls-LLS-5.8-800-20171207-111607.apk HTTP/1.1
User-Agent: Download4cj/1.0.7
Range: bytes=0-0
Keep-Alive: timeout=600, max=1000
Host: cdn.llscdn.com
Connection: Keep-Alive

"""

    var cfg = TlsClientConfig("")
    cfg.verifyMode = VerifyNone
    let arr = Array<UInt8>(409600,item:0)

    let s1 = TlsSocket(TCP,"cdn.llscdn.com",443,cfg)
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


    let f3 = spawn{
        down3()
    }

    f1.get()
    f2.get()
    f3.get()
    return 0
}


func down1():Unit{
            let str2 = """
GET /yy/files/xs8qmxn8-lls-LLS-5.8-800-20171207-111607.apk HTTP/1.1
User-Agent: Download4cj/1.0.7
Range: bytes=0-14664668
Keep-Alive: timeout=600, max=1000
Host: cdn.llscdn.com
Connection: Keep-Alive

"""
         var cfg = TlsClientConfig("")
            cfg.verifyMode = VerifyNone
            let s2 = TlsSocket(TCP,"cdn.llscdn.com",443,cfg)
            let arr2 = Array<UInt8>(409600,item:0)
            s2.connect()
            s2.write(str2.toUtf8Array())
            var len2=0
            while(len2 < 14664669){

                //try{
                     len2 += s2.read(arr2, Duration.hour*1)
                // }catch(e:Exception){
                //      let isClosed = s2.isClosed()
                //     print("-----------------------------------isClosed="+isClosed.toString()+"-----------------------------len="+len2.toString())
                // }
            }
            println("1len2="+len2.toString())
            s2.close()
            println("s2 done")

}

func down2():Unit{
            let str3 = """
GET /yy/files/xs8qmxn8-lls-LLS-5.8-800-20171207-111607.apk HTTP/1.1
User-Agent: Download4cj/1.0.7
Range: bytes=14664669-29329336
Keep-Alive: timeout=600, max=1000
Host: cdn.llscdn.com
Connection: Keep-Alive

"""
            var cfg = TlsClientConfig("")
            cfg.verifyMode = VerifyNone
            let s3 = TlsSocket(TCP,"cdn.llscdn.com",443,cfg)
            let arr3 = Array<UInt8>(409600,item:0)
            s3.connect()
            s3.write(str3.toUtf8Array())
            var len3=0
            while(len3 < 14664668){
                // try{
                     len3 += s3.read(arr3, Duration.hour*1)
                // }catch(e:Exception){
                //      let isClosed = s3.isClosed()
                //     print("-----------------------------------isClosed="+isClosed.toString()+"-----------------------------len="+len3.toString())
                // }
            }
            println("1len3="+len3.toString())
            s3.close()
            println("s3 done")
}


func down3(){
             let str4 = """
GET /yy/files/xs8qmxn8-lls-LLS-5.8-800-20171207-111607.apk HTTP/1.1
User-Agent: Download4cj/1.0.7
Range: bytes=29329337-43994004
Keep-Alive: timeout=600, max=1000
Host: cdn.llscdn.com
Connection: Keep-Alive

"""
            var cfg = TlsClientConfig("")
            cfg.verifyMode = VerifyNone
            let s4 = TlsSocket(TCP,"cdn.llscdn.com",443,cfg)
            let arr4 = Array<UInt8>(409600,item:0)
            s4.connect()
            s4.write(str4.toUtf8Array())
            var len4=0
            while(len4 < 14664668){
                //try{
                     len4 += s4.read(arr4, Duration.hour*1)
                // }catch(e:Exception){
                //      let isClosed = s4.isClosed()
                //      print("-----------------------------------isClosed="+isClosed.toString()+"-----------------------------len="+len4.toString())

                // }
            }
            println("1len4="+len4.toString())
            s4.close()
            println("s4 done")
}
