

from std import io.*
from std import time.*
from net import http.*
from std import socket.*
from encoding import url.*
from std import fs.*
from std import runtime.*

main(){
    var url:String = "http://192.168.33.37:8080/examples/1G.txt"
    let r = http.Request(GET,url)
    let arr = ByteArrayStream()
    r.copyTo(arr)
    let soc = Socket(TCP,"192.168.33.37", 8080)
    soc.connect()
    soc.write(arr.readToEnd())
    println("soc start =======================")
    var fsOut: File = File("./1G.txt", OpenOption.Create(false))
    let output = BufferedOutputStream(fsOut,4096)

    while(true){
        var buffer = Array<Byte>(4096,{i => 0})
        var buffer2 = Array<Byte>(4096,{i => 0})
        let len = soc.read(buffer)
        let arr2 =ByteArrayStream()
        arr.write(buffer)
        arr.read(buffer2)
        arr2.write(buffer2)
        }

}
