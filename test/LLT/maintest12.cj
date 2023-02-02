

from okdownload import okdownload.*
from okhttp import okhttp.*
from std import fs.*
from std import io.*
from std import runtime.*



main(){
    ///home/hhs/ok-download/ci_test/test_temp/run/maintest09_cj_1675241733_3725836/download/100M.txt
    var url:String = "http://192.168.33.37:8080/examples/100M.txt"
    var connection:DownloadConnection = OkDownload.withs().connectionFactory().create(url)
    let con = connection as DownloadOkHttp3Connection
    con.getOrThrow().execute()
    var stream = ByteArrayStream()
    var fsOut: File = File("/home/hhs/ok-download/TO100M.txt", OpenOption.Create(false))
    try{
        let output = BufferedOutputStream(fsOut,4096)
        let source:Source = con.getOrThrow().getInputStream()
        while(true){
            let len = source.read(stream,4096)
            if(len > 0){
                output.write(stream.readToEnd())
                println("maxHeapSize="+MemoryInfo.maxHeapSize.toString()+"-------allocatedHeapSize="+MemoryInfo.allocatedHeapSize.toString()+"------heapPhysicalMemory="+MemoryInfo.heapPhysicalMemory.toString())
                output.flush()
            }else{
                break
            }
        }
    }finally{
        fsOut.close()
    }

}


