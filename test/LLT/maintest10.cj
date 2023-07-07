

from okdownload import okdownload.*
from std import collection.*
from std import fs.*
from std import time.*
from std import runtime.*


func runBench(n:Int64,fileName:String):Unit{
    //var url:String = "http://127.0.0.1:8080/examples/${fileName}.txt"
    //var url:String = "http://192.168.33.37:8080/examples/${fileName}.txt"
    var url:String = "http://139.9.247.2:38156/jenkins/job/okdownload/10/artifact/${fileName}.txt"

    //var url:String = "http://imgsrc.baidu.com/forum/w%3D580/sign=eed1753686d6277fe9123230183a1f63/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"
    //var url:String = "http://a2.dxiazaicc.com/down4/win7sp2_downcc.com.zip"
    //var url:String = "https://nodejs.org/dist/v11.2.0/node-v11.2.0.tar.gz"
    //var url:String = "https://cdn.llscdn.com/yy/files/xs8qmxn8-lls-LLS-5.8-800-20171207-111607.apk"
    //var url:String = "https://cdn-file-ssl-pc.ludashi.com/pc/appstore/ludashi/ludashisetup2020.exe"  //162M
    //var url:String = "https://cr8.197946.com/occtpt_11.0.18_cr173.com.exe"
    //var url:String = "https://cr8.197946.com/splashy2.0.1.0.exe" //75.2M



    //var url:String = "https://cr8.197946.com/syncfolders-v3.5.223_cr173.com.zip"  //1.3M
    //var url:String = "https://cr8.197946.com/lenovobatterysetting.zip"              //10.6M
    //var url:String = "https://cr8.197946.com/virtualbox-7.0.4-154605-cr173.exe" //106M
    //var url:String = "https://cr8.197946.com/colorconsole-v6.66_cr173.com.zip"    //539KB
    //var url:String = "https://cr8.197946.com/ismyhdok_3.77.zip"                   //218KB
    //var url:String = "https://cr8.197946.com/zdywinrml.zip"  //34K
    //var url:String = "https://cr8.197946.com/yjcdtjfzwjklj.zip" //1K




	if(Directory.exists("download")){
        Directory.delete("download",recursive:true)
    }
    let dir=Directory.create("download",recursive:true)
    var e :Int64 = 0
	for (i in 0..n){
	    let s = Time.now()
		let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        task.execute(MyListen())
        let e0 = Time.since(s).nanoseconds()
        e += e0
        if(Directory.exists("download")){
            Directory.delete("download",recursive:true)
            // Directory.move("download","${fileName}_download_${i}",true)
        }
        Directory.create("download",recursive:true)
	}

	print("[ PASSED ] CASE: okdownload_${fileName}_${n} (${e} ns, ${Float64(e)/Float64(n)} ns/op)\n", flush:true)
}

main(){
	println("TCS: okdownload, time elapsed: 1 ns, RESULT:")
    let count = [1,10,100,1000,10000]
	//let count = [1,10,100,1000,10000]
    //let files = ["1B","1K","1M","10M"]
    let files = ["1B"]

    for (f in files){
        for (n in count){
            runBench(n,f)
        }
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
    }
}


