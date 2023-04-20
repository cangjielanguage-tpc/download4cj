// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from okdownload import okdownload.*
from std import collection.*
from std import fs.*

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
     task.enqueue(MyListen())

     sleep(1000*1000*1000*3)
     if(isComplete){
        return 0
     }else{
        return 1
     }
}

public class MyListen<: DownloadListener{

    public func taskStart(task:DownloadTask):Unit{
    }

    public func connectTrialStart(task:DownloadTask,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
    }

    public func connectTrialEnd(task:DownloadTask,responseCode:Int64,responseHeaderFields:HashMap<String, ArrayList<String>>):Unit{
    }

    public func downloadFromBeginning(task:DownloadTask):Unit{
    }

    public func downloadFromBreakpoint(task:DownloadTask):Unit{
    }

    public func connectStart(task:DownloadTask,blockIndex:Int64,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
    }

    public func connectEnd(task:DownloadTask,blockIndex:Int64,responseCode:Int64,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
    }

    public func fetchStart(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit{
    }

    public func fetchProgress(task:DownloadTask,blockIndex:Int64,increaseBytes:Int64):Unit{
    }

    public func fetchEnd(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit{
    }

    public func taskEnd(task:DownloadTask,realCause:Option<Exception>):Unit{
        isComplete = true
    }
}

