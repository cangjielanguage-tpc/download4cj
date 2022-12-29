// EXEC: cjc %import-path %L %l %f
// EXEC: ./main


from okdownload import okdownload.*
from std import collection.*
from std import fs.*

main(){

    var url:String = "http://imgsrc.baidu.com/forum/w%3D580/sign=eed1753686d6277fe9123230183a1f63/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"
    var url2:String = "http://a2.dxiazaicc.com/down4/win7sp2_downcc.com.zip"

    let lastIndex:Int64 = url.lastIndexOf(".").getOrThrow()
    let lastIndex2:Int64 = url2.lastIndexOf(".").getOrThrow()
    var FileEnds = url.substring(lastIndex)
    var FileEnds2 = url2.substring(lastIndex2)


    let filenamePre:String = "single-test"
    let filename = filenamePre+FileEnds
    let filename2 = filenamePre+FileEnds2


    let parentFilePath:Path = Path("./fileDownLoad0")
    var parentFile:Option<Directory> = Option<Directory>.None

    if (!Directory.exists(parentFilePath)) {
        parentFile = Directory.create(parentFilePath, recursive: true)
        println("进来了")
    }else{
        println("没进来")
    }

    //let parentFile:File = File(parentFilePath,OpenOption.Create(true))
    let task:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
         .setFilename(filename)
         // the minimal interval millisecond for callback progress
         .setMinIntervalMillisCallbackProcess(30)
         // do re-download even if the task has already been completed in the past.
         .build()

    //let parentFile:File = File(parentFilePath,OpenOption.Create(true))
    let task2:DownloadTask = DownloadTaskBuilder(url2, parentFile.getOrThrow())
         .setFilename(filename2)
         // the minimal interval millisecond for callback progress
         .setMinIntervalMillisCallbackProcess(30)
         // do re-download even if the task has already been completed in the past.
         .setPassIfAlreadyCompleted(false)
         .build()


    let tasklists:ArrayList<DownloadTask> = ArrayList<DownloadTask>()
    tasklists.append(task)
    tasklists.append(task2)
    let tasks:Array<DownloadTask> = Array<DownloadTask>(tasklists)


     DownloadTask.enqueues(tasks,DefaultTransmitListener())
     sleep(1000*1000*1000*60)
     println("jieshu")
}

