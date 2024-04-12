// EXEC: cjc %import-path %L %l %f
// EXEC: ./main


from download4cj import download4cj.*
from std import collection.*
from std import fs.*

//目的 主要为了验证文件大一点的情况

var isComplete = false

main(){

        var url:String = "https://ucdl.25pp.com/fs08/2024/04/07/1/120_55c06b68501c1bea3405c58cda4ad3b9.apk"

        let parentFilePath:Path = Path("./fileDownLoad")
        var parentFile:Option<Directory> = Option<Directory>.None

        if (!Directory.exists(parentFilePath)) {
            parentFile = Directory.create(parentFilePath, recursive: true)
        }else{
        }

        let task:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
            .setMinIntervalMillisCallbackProcess(30)
            .build()
        task.execute(MyListen())

        if(isComplete && task.getConnectionCount()==4){
            // 小于1M   1M-5M  5M-50M  50M-100M  大于100M
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

