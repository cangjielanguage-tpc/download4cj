

from okhttp import okhttp.*
from std import fs.*
from std import io.*
from std import runtime.*



main(){
    ///home/hhs/ok-download/ci_test/test_temp/run/maintest09_cj_1675241733_3725836/download/100M.txt
    var url:String = "http://192.168.33.37:8080/examples/100M.txt"

    let client:Option<OkHttpClient> = OkHttpClient(OkHttpClient.builder())
    let requestBuilder:RequestBuilder = Request.builder().url(url)
    var request:Option<Request> = requestBuilder.build()
    var response:Option<Response> = client.getOrThrow().newCall(request.getOrThrow()).execute()

    //var connection:DownloadConnection = OkDownload.withs().connectionFactory().create(url)
    //let con = connection as DownloadOkHttp3Connection
    //con.getOrThrow().execute()
    var stream = ByteArrayStream()
    var fsOut: File = File("/home/hhs/ok-download/TO100M.txt", OpenOption.Create(false))
    let source:Source = response.getOrThrow().getBody().getOrThrow().getSource()

    try{
        let output = BufferedOutputStream(fsOut,4096)
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


