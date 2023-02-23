


from okdownload import okdownload.*
from std import collection.*
from std import fs.*

var exception = Option<String>.None

//目的 主要为了验证地址出错时候的情况

main(){

        //var url:String = "https://nodejs.org/dist"
        var url:String = "http://imgsrc.baidu.com/forum/w%3D580"
        //var url:String = "https://www.voidtools.com/Everything-1.4.1.1017.x64-Setup.exe"
        let dir=Directory.create("download",recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()



        var flag=1
        try{
            task.execute(MyListen())
        }catch(e:Exception){
            flag=0
        }

        if(File.exists("download/w%3D580")){
            println("true1")
        }else{
            println("fasle1")
        }

        if(flag == 0){
            println("true2")
        }else{
            println("fasle2")
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


