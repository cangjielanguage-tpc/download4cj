// EXEC: cjc %import-path %L %l %f
// EXEC: ./main


from okdownload import okdownload.*
from std import collection.*
from std import fs.*

var i = 0

//目的 主要为了验证循环同步下载


main(){

    for(i in 0..3){

        var url:String = "http://imgsrc.baidu.com/forum/w%3D580/sign=eed1753686d6277fe9123230183a1f63/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"
        let lastIndex:Int64 = url.lastIndexOf(".").getOrThrow()
        var FileEnds = url.substring(lastIndex)

        let filenamePre:String = "single-test"
        let filename = filenamePre+FileEnds

        let parentFilePath:Path = Path("./fileDownLoad"+i.toString())
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
    }

    if(i == 3){
      return 0
    }else{
      return 1
    }

}

public class MyListen<: DownloadListener{
    public func taskStart(task:DownloadTask):Unit{
        println("==================taskStart=======================")
        println("task.getId="+task.getId().toString())
    }
    public func connectTrialStart(task:DownloadTask,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
         println("==================connectTrialStart=======================")
         println("requestHeaderFields="+requestHeaderFields.toString())
         println("task.getId="+task.getId().toString())
    }

    public func connectTrialEnd(task:DownloadTask,responseCode:Int64,responseHeaderFields:HashMap<String, ArrayList<String>>):Unit{
         println("===============connectTrialEnd===================")
         println("responseCode="+responseCode.toString())
         println("responseHeaderFields="+responseHeaderFields.toString())
         println("task.getId="+task.getId().toString())
    }

    public func downloadFromBeginning(task:DownloadTask):Unit{
         println("===============downloadFromBeginning===================")
         println("task.getId="+task.getId().toString())
    }

    public func downloadFromBreakpoint(task:DownloadTask):Unit{
         println("===============downloadFromBreakpoint===================")
         println("task.getId="+task.getId().toString())

    }

    public func connectStart(task:DownloadTask,blockIndex:Int64,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
         println("===============connectStart===================")
         println("blockIndex="+blockIndex.toString())
         println("requestHeaderFields="+requestHeaderFields.toString())
         println("task.getId="+task.getId().toString())
    }

    public func connectEnd(task:DownloadTask,blockIndex:Int64,responseCode:Int64,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
         println("===============connectEnd===================")
         println("blockIndex="+blockIndex.toString())
         println("responseCode="+responseCode.toString())
         println("requestHeaderFields="+requestHeaderFields.toString())
         println("task.getId="+task.getId().toString())
    }

    public func fetchStart(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit{
         println("===============fetchStart===================")
         println("blockIndex="+blockIndex.toString())
         println("contentLength="+contentLength.toString())
         println("task.getId="+task.getId().toString())
    }

    public func fetchProgress(task:DownloadTask,blockIndex:Int64,increaseBytes:Int64):Unit{
         println("===============fetchProgress===================")
         println("blockIndex="+blockIndex.toString())
         println("increaseBytes="+increaseBytes.toString())
         println("task.getId="+task.getId().toString())
    }

    public func fetchEnd(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit{
         println("===============fetchEnd===================")
         println("blockIndex="+blockIndex.toString())
         println("contentLength="+contentLength.toString())
         println("task.getId="+task.getId().toString())
    }

    public func taskEnd(task:DownloadTask,realCause:Option<Exception>):Unit{
         println("===============taskEnd===================")
         println("task.getId="+task.getId().toString())
         i++
    }
}

