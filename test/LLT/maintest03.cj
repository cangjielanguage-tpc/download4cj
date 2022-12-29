// EXEC: cjc %import-path %L %l %f
// EXEC: ./main


from okdownload import okdownload.*
from std import collection.*
from std import fs.*

main(){

    var url:String = "https://mbdp01.bdstatic.com/static/landing-pc/js/news.9aff1630.js"
    let lastIndex:Int64 = url.lastIndexOf(".").getOrThrow()
    var FileEnds = url.substring(lastIndex)

    let filenamePre:String = "single-test"
    let filename = filenamePre+FileEnds

    let parentFilePath:Path = Path("./fileDownLoad2")
    var parentFile:Option<Directory> = Option<Directory>.None

    if (!Directory.exists(parentFilePath)) {
        parentFile = Directory.create(parentFilePath, recursive: true)
        println("进来了")
    }else{
        println("没进来")
    }

    let task:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
         .setFilename(filename)
         // the minimal interval millisecond for callback progress
         .setMinIntervalMillisCallbackProcess(30)
         // do re-download even if the task has already been completed in the past.
         .build()

     task.execute(DefaultTransmitListener())
     println("taskId="+task.getId().toString())
     println("fileName="+task.getFilename().getOrThrow())
     println("url="+task.getUrl())
     println("uri="+task.getUri().toString())
     println("ProvidedPathFile="+task.getProvidedPathFile().getOrThrow().info.path.toString())
     println("ReadBufferSize="+task.getReadBufferSize().toString())
     println("FlushBufferSize="+task.getFlushBufferSize().toString())
     println("MinIntervalMillisCallbackProcess="+task.getMinIntervalMillisCallbackProcess().toString())
     println("ConnectionCount="+task.getConnectionCount().toString())
}


