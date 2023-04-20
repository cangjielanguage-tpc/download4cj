// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from okdownload import okdownload.*
from std import collection.*
from std import fs.*


var isComplete = false

main(){

        var url:String = "https://cdn.llscdn.com/yy/files/xs8qmxn8-lls-LLS-5.8-800-20171207-111607.apk"


        let filename:String = "single-test"

        let parentFilePath:Path = Path("./fileDownLoad")
        var parentFile:Option<Directory> = Option<Directory>.None

        if (!Directory.exists(parentFilePath)) {
            parentFile = Directory.create(parentFilePath, recursive: true)
        }else{
        }

        let task:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
            .setMinIntervalMillisCallbackProcess(30)
            .build()
        task.enqueue(MyListen())
        sleep(1000*1000*1000)
        task.cancel()

        let blockList:ArrayList<BlockInfo> = task.getBlockInfoList().getOrThrow()
        for(oneitem in blockList){
            println("==========================================================")
            println("blockinfoCurrent="+oneitem.getCurrentOffset().toString()+"=========blockinfoContent="+oneitem.getContentLength().toString()+"=========blockinfoStart="+oneitem.getStartOffset().toString())
            println("blockinfoRangeLeft="+oneitem.getRangeLeft().toString()+"=========blockinfoRangeRight="+oneitem.getRangeRight().toString())
            println("==========================================================")
        }

        sleep(1000*1000*1000*2)
        task.execute(MyListen())
        if(isComplete && task.getConnectionCount()==3){
            println(true)
            return 0
        }else{
            println(false)
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

