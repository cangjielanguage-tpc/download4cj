// EXEC: cjc %import-path %L %l %f
// EXEC: ./main



from okdownload import okdownload.*
from std import collection.*
from std import fs.*

main(){
    //var url:String = "http://a2.dxiazaicc.com/down4/rufusv3.18_downcc.com.zip"
    //var url:String = "http://a2.dxiazaicc.com/down4/win7sp2_downcc.com.zip"
    //var url:String = "https://nodejs.org/dist/v11.2.0/node-v11.2.0.tar.gz"

    var url:String = "https://cdn.llscdn.com/yy/files/xs8qmxn8-lls-LLS-5.8-800-20171207-111607.apk"
    let lastIndex:Int64 = url.lastIndexOf(".").getOrThrow()
    var FileEnds = url.substring(lastIndex)
    //println("FileEnds="+FileEnds)

    let filenamePre:String = "single-test"
    let filename = filenamePre+FileEnds

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
         .setPassIfAlreadyCompleted(false)
         .build()

     task.execute(DefaultTransmitListener())
}

