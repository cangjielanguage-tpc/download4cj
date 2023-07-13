// EXEC: cjc %import-path %L %l %f
// EXEC: ./main


from okdownload import okdownload.*
from std import collection.*
from std import fs.*
from std import sync.sleep
from std import time.Duration
//目的 主要为了验证异步下载单个


var isComplete = false


main(){

    var url:String = "http://imgsrc.baidu.com/forum/w%3D580/sign=eed1753686d6277fe9123230183a1f63/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"
    let lastIndex:Int64 = url.lastIndexOf(".").getOrThrow()
    var FileEnds = url.substring(lastIndex)

    let filenamePre:String = "single-test"
    let filename = filenamePre+FileEnds

    let parentFilePath:Path = Path("./fileDownLoad0")
    var parentFile:Option<Directory> = Option<Directory>.None

    if (!Directory.exists(parentFilePath)) {
        parentFile = Directory.create(parentFilePath, recursive: true)
    }else{
    }

    let task:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
         .setFilename(filename)
         .setMinIntervalMillisCallbackProcess(30)
         .build()

     task.enqueue(MyListen())
     sleep(3 * Duration.second)
     if(isComplete){
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

