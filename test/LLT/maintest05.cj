// EXEC: cjc %import-path %L %l %f
// EXEC: ./main


from okdownload import okdownload.*
from std import collection.*
from std import fs.*

main(){

    var url:String = "http://imgsrc.baidu.com/forum/w%3D580/sign=eed1753686d6277fe9123230183a1f63/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"


    let parentFilePath:Path = Path("./fileDownLoad0")
    var parentFile:Option<Directory> = Option<Directory>.None

    if (!Directory.exists(parentFilePath)) {
        parentFile = Directory.create(parentFilePath, recursive: true)
        println("进来了")
    }else{
        println("没进来")
    }

    var filename0 = "0.jpg"
    var filename1 = "1.jpg"
    var filename2 = "2.jpg"
    var filename3 = "3.jpg"
    var filename4 = "4.jpg"


    //let parentFile:File = File(parentFilePath,OpenOption.Create(true))
    let task:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
        .setFilename(filename0)
         // the minimal interval millisecond for callback progress
         .setMinIntervalMillisCallbackProcess(30)
         // do re-download even if the task has already been completed in the past.
         .build()

    //let parentFile:File = File(parentFilePath,OpenOption.Create(true))
    let task1:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
        .setFilename(filename1)
         // the minimal interval millisecond for callback progress
         .setMinIntervalMillisCallbackProcess(30)
         // do re-download even if the task has already been completed in the past.
         .build()

     let task2:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
        .setFilename(filename2)
         // the minimal interval millisecond for callback progress
         .setMinIntervalMillisCallbackProcess(30)
         // do re-download even if the task has already been completed in the past.
         .build()

    //let parentFile:File = File(parentFilePath,OpenOption.Create(true))
    let task3:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
        .setFilename(filename3)
         // the minimal interval millisecond for callback progress
         .setMinIntervalMillisCallbackProcess(30)
         // do re-download even if the task has already been completed in the past.
         .build()

    let task4:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
        .setFilename(filename4)
        // the minimal interval millisecond for callback progress
        .setMinIntervalMillisCallbackProcess(30)
        // do re-download even if the task has already been completed in the past.
        .build()

    let tasklists:ArrayList<DownloadTask> = ArrayList<DownloadTask>()
    tasklists.append(task)
    tasklists.append(task1)
    tasklists.append(task2)
    tasklists.append(task3)
    tasklists.append(task4)
    let tasks:Array<DownloadTask> = Array<DownloadTask>(tasklists)


     DownloadTask.enqueues(tasks,DefaultTransmitListener())
     sleep(1000*1000*1000*8)
     println("jieshu")
}

