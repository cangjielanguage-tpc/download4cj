// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from download4cj import download4cj.*
from std import collection.*
from std import fs.*
from std import sync.sleep
from std import time.Duration
var i = 0

//目的 主要为了验证异步下载多个相同的

main(){

    var url:String = "http://imgsrc.baidu.com/forum/w%3D580/sign=eed1753686d6277fe9123230183a1f63/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"


    let parentFilePath:Path = Path("./fileDownLoad0")
    var parentFile:Option<Directory> = Option<Directory>.None

    if (!Directory.exists(parentFilePath)) {
        parentFile = Directory.create(parentFilePath, recursive: true)
    }else{
    }

    var filename0 = "0.jpg"
    var filename1 = "1.jpg"
    var filename2 = "2.jpg"
    var filename3 = "3.jpg"
    var filename4 = "4.jpg"


    let task:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
        .setFilename(filename0)
         .setMinIntervalMillisCallbackProcess(30)
         .build()

    let task1:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
        .setFilename(filename1)
         .setMinIntervalMillisCallbackProcess(30)
         .build()

     let task2:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
        .setFilename(filename2)
         .setMinIntervalMillisCallbackProcess(30)
         .build()

    let task3:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
        .setFilename(filename3)
         .setMinIntervalMillisCallbackProcess(30)
         .build()

    let task4:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
        .setFilename(filename4)
        .setMinIntervalMillisCallbackProcess(30)
        .build()

    let tasklists:ArrayList<DownloadTask> = ArrayList<DownloadTask>()
    tasklists.append(task)
    tasklists.append(task1)
    tasklists.append(task2)
    tasklists.append(task3)
    tasklists.append(task4)
    let tasks:Array<DownloadTask> = Array<DownloadTask>(tasklists)


     DownloadTask.enqueues(tasks,MyListen())
     sleep(8 * Duration.second)
     if(i == tasklists.size){
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
         i++
    }
}

