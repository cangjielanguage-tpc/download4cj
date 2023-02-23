


from okdownload import okdownload.*
from std import collection.*
from std import fs.*

var exception = Option<String>.None

//目的 主要为了验证地址出错时候的情况

main(){

        var url:String = "http://imgsrc.baidu.com/forum/w%3D580"
        let dir01=Directory.create("download01",recursive:true)
        let dir02=Directory.create("download02",recursive:true)
        let dir03=Directory.create("download03",recursive:true)
        let dir04=Directory.create("download04",recursive:true)
        let dir05=Directory.create("download05",recursive:true)
        let task01:DownloadTask = DownloadTaskBuilder(url,dir01).build()
        let task02:DownloadTask = DownloadTaskBuilder(url,dir02).build()
        let task03:DownloadTask = DownloadTaskBuilder(url,dir03).build()
        let task04:DownloadTask = DownloadTaskBuilder(url,dir04).build()
        let task05:DownloadTask = DownloadTaskBuilder(url,dir05).build()

        let tasks=Array<DownloadTask>([task01,task02,task03,task04,task05])
        DownloadTask.enqueues(tasks,MyListen())

        sleep(5*1000*1000*1000)

            if(File.exists("download01/w%3D580")){
                println("true1")
            }else{
                println("false1")
            }

            if(FileInfo("download05/w%3D580").length == 0){
                println("true11")
            }else{
                println("false11")
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
    }
}


