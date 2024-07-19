// EXEC: cjc %import-path %L %l %f
// EXEC: ./main


import download4cj.*
import std.collection.*
import std.fs.*


var isComplete = false

//目的 主要为了验证同步下载

main(){

        //http://a2.dxiazaicc.com/down4/win7sp2_downcc.com.zip
        //var url:String = "http://a2.dxiazaicc.com/down4/rufusv3.18_downcc.com.zip"
        //var url:String = "http://a2.dxiazaicc.com/down4/win7sp2_downcc.com.zip"
        //var url:String = "https://nodejs.org/dist/v11.2.0/node-v11.2.0.tar.gz"
        //var url:String = "https://cdn.llscdn.com/yy/files/xs8qmxn8-lls-LLS-5.8-800-20171207-111607.apk"

        var url:String = "https://www.voidtools.com/Everything-1.4.1.1017.x64-Setup.exe"
        //var url:String = "https://image.baidu.com/search/down?tn=download&ipn=dwnl&word=download&ie=utf8&fr=result&url=https%3A%2F%2Fup.enterdesk.com%2Fedpic%2Fc5%2F3a%2Fe5%2Fc53ae5ec144c1d16105303c9d9bf68bb.jpg&thumburl=https%3A%2F%2Fimg0.baidu.com%2Fit%2Fu%3D2171411284%2C1924893541%26fm%3D253%26fmt%3Dauto%26app%3D138%26f%3DJPEG%3Fw%3D889%26h%3D500"


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

