// EXEC: cjc %import-path %L %l %f
// EXEC: ./main


from download4cj import download4cj.*
from std import collection.*
from std import fs.*

var isComplete = false
var mFileName = ""
var mConnectionCount = 0
var mUrl = ""

//目的 主要为了验证一些配置参数


main(){

    var url:String = "https://mbdp01.bdstatic.com/static/landing-pc/js/news.9aff1630.js"
    let lastIndex:Int64 = url.lastIndexOf(".").getOrThrow()
    var FileEnds = url[lastIndex..]

    let filenamePre:String = "single-test"
    let filename = filenamePre+FileEnds

    let parentFilePath:Path = Path("./fileDownLoad2")
    var parentFile:Option<Directory> = Option<Directory>.None

    if (!Directory.exists(parentFilePath)) {
        parentFile = Directory.create(parentFilePath, recursive: true)
    }else{
    }

    let task:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
         .setFilename(filename)
         .setMinIntervalMillisCallbackProcess(30)
         .build()

     task.execute(MyListen())
     mFileName = task.getFilename().getOrThrow()
     mConnectionCount = task.getConnectionCount()
     mUrl = task.getUrl()
     println("taskId="+task.getId().toString())
     println("fileName="+task.getFilename().getOrThrow())
     println("url="+task.getUrl())
     println("uri="+task.getUri().toString())
     println("ProvidedPathFile="+task.getProvidedPathFile().getOrThrow().info.path.toString())
     println("ReadBufferSize="+task.getReadBufferSize().toString())
     println("FlushBufferSize="+task.getFlushBufferSize().toString())
     println("MinIntervalMillisCallbackProcess="+task.getMinIntervalMillisCallbackProcess().toString())
     println("ConnectionCount="+task.getConnectionCount().toString())

     if(isComplete && "single-test.js"==mFileName && mConnectionCount == 1 && "https://mbdp01.bdstatic.com/static/landing-pc/js/news.9aff1630.js"==mUrl){
        return 0
     }else{
        return 1
     }
}


public class MyListen<: DownloadListener{
    public func taskStart(task:DownloadTask):Unit{
         task.getUrl()
    }
    public func connectTrialStart(task:DownloadTask,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
         task.getUrl()
         requestHeaderFields.size
    }
    public func connectTrialEnd(task:DownloadTask,responseCode:Int64,responseHeaderFields:HashMap<String, ArrayList<String>>):Unit{
         task.getUrl()
         responseHeaderFields.size
         responseCode.toString()
    }
    public func downloadFromBeginning(task:DownloadTask):Unit{
         task.getUrl()
    }
    public func downloadFromBreakpoint(task:DownloadTask):Unit{
         task.getUrl()
    }
    public func connectStart(task:DownloadTask,blockIndex:Int64,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
         task.getUrl()
         blockIndex.toString()
         requestHeaderFields.toString()
    }
    public func connectEnd(task:DownloadTask,blockIndex:Int64,responseCode:Int64,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
         task.getUrl()
         blockIndex.toString()
         responseCode.toString()
         requestHeaderFields.toString()
    }
    public func fetchStart(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit{
         task.getUrl()
         blockIndex.toString()
         contentLength.toString()
    }
    public func fetchProgress(task:DownloadTask,blockIndex:Int64,increaseBytes:Int64):Unit{
         task.getUrl()
         blockIndex.toString()
         increaseBytes.toString()
    }
    public func fetchEnd(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit{
         task.getUrl()
         blockIndex.toString()
         contentLength.toString()
    }
    public func taskEnd(task:DownloadTask,realCause:Option<Exception>):Unit{
         task.getUrl()
         realCause is Option<Exception>
         isComplete = true
    }
}

