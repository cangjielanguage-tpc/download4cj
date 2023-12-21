// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from download4cj import download4cj.*
from std import collection.*
from std import fs.*
from std import sync.sleep
from std import time.Duration
var isComplete = false

main(){

    // var url1:String = "https://cdn.llscdn.com/yy/files/xs8qmxn8-lls-LLS-5.8-800-20171207-111607.apk"
    // var url2:String = "http://imgsrc.baidu.com/forum/w%3D580/sign=eed1753686d6277fe9123230183a1f63/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"
    // var url3:String = "https://cr8.197946.com/lenovobatterysetting.zip"

    var url1:String = "http://imgsrc.baidu.com/forum/w%3D580/sign=eed1753686d6277fe9123230183a1f63/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"
    var url2:String = "http://a2.dxiazaicc.com/down4/win7sp2_downcc.com.zip"
    var url3:String = "http://a2.dxiazaicc.com/down4/rufusv3.18_downcc.com.zip"

    //  var url1:String = "http://a2.dxiazaicc.com/down4/win7sp2_downcc.com.zip"
    //  var url2:String = "http://a2.dxiazaicc.com/down4/win7sp2_downcc.com.zip"
    //  var url3:String = "http://a2.dxiazaicc.com/down4/win7sp2_downcc.com.zip"



    let lastIndex1:Int64 = url1.lastIndexOf(".").getOrThrow()
    let lastIndex2:Int64 = url2.lastIndexOf(".").getOrThrow()
    let lastIndex3:Int64 = url3.lastIndexOf(".").getOrThrow()
    var FileEnds1 = url1[lastIndex1..]
    var FileEnds2 = url2[lastIndex2..]
    var FileEnds3 = url3[lastIndex3..]


    let filenamePre:String = "single-test"
    let filename1 = filenamePre+"111"+FileEnds1
    let filename2 = filenamePre+"222"+FileEnds2
    let filename3 = filenamePre+"333"+FileEnds3


    let parentFilePath:Path = Path("./fileDownLoad0")
    var parentFile:Option<Directory> = Option<Directory>.None

    if (!Directory.exists(parentFilePath)) {
        parentFile = Directory.create(parentFilePath, recursive: true)
    }else{
    }

    let task1:DownloadTask = DownloadTaskBuilder(url1, parentFile.getOrThrow())
         .setFilename(filename1)
         .setMinIntervalMillisCallbackProcess(30)
         .build()

    let task2:DownloadTask = DownloadTaskBuilder(url2, parentFile.getOrThrow())
         .setFilename(filename2)
         .setMinIntervalMillisCallbackProcess(30)
         .build()

    let task3:DownloadTask = DownloadTaskBuilder(url3, parentFile.getOrThrow())
         .setFilename(filename3)
         .setMinIntervalMillisCallbackProcess(30)
         .build()


    let tasklists:ArrayList<DownloadTask> = ArrayList<DownloadTask>()
    tasklists.append(task1)
    tasklists.append(task2)
    tasklists.append(task3)
    let tasks:Array<DownloadTask> = Array<DownloadTask>(tasklists)


     DownloadTask.enqueues(tasks,MyListen())
     sleep(Duration.second*2)
     DownloadTask.cancels(tasks)

     for(oneTask in tasks){
        println("==========================================================")
        let blockList:Option<ArrayList<BlockInfo>> = oneTask.getBlockInfoList()
        if(let Some(i) <- blockList){
            for(oneitem in i){
               println("blockinfoCurrent="+oneitem.getCurrentOffset().toString()+"=========blockinfoContent="+oneitem.getContentLength().toString())
            }
        }else{
            println("此时的这个task的blockList为null")
        }
        println("==========================================================")
     }

     sleep(Duration.second*2)
     DownloadTask.enqueues(tasks,MyListen())
     sleep(Duration.second*30)
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


