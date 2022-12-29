// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from okdownload import okdownload.*
from std import collection.*
from std import fs.*

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
            println("进来了")
        }else{
            println("没进来")
        }

        let task:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
            .setFilename(filename)
            // the minimal interval millisecond for callback progress
            .setMinIntervalMillisCallbackProcess(30)
            // do re-download even if the task has already been completed in the past.
            .setPassIfAlreadyCompleted(false)
            .build()

        task.execute(DefaultTransmitListener())
    }

}

