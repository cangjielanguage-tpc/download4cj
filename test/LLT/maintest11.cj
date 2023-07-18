


from download4cj import download4cj.*
from std import collection.*
from std import fs.*
from std import time.*
from std import sync.sleep
from std import time.Duration

func runBench(n:Int64,fileName:String):Unit{
    var url:String = "https://www.voidtools.com/Everything-1.4.1.1017.x64-Setup.exe"
	if(Directory.exists("download")){
        Directory.delete("download",recursive:true)
    }
    let dir=Directory.create("download",recursive:true)
    var e :Int64 = 0
	for (i in 0..n){
	    let s = DateTime.now()
		let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        task.execute(MyListen())
        let e0 = Duration.since(s).toNanoseconds()
        e += e0
        if(Directory.exists("download")){
            Directory.delete("download",recursive:true)
        }
        Directory.create("download",recursive:true)
	}

	print("[ PASSED ] CASE: download4cj_${fileName}_${n} (${e} ns, ${Float64(e)/Float64(n)} ns/op)\n", flush:true)
}

main(){
	println("TCS: download4cj, time elapsed: 1 ns, RESULT:")
	let count = [100]
    let files = ["1B"]
    for (f in files){
        for (n in count){
            runBench(n,f)
        }
    }
}

public class MyListen<: DownloadListener{
    public var flag01=0
    public var flag02=0
    public var flag03=0
    public var flag04=0
    public var flag05=0
    public var flag06=0
    public var flag07=0
    public var flag08=0
    public var flag09=0
    public var flag10=0
    public var flag11=0
    public func taskStart(task:DownloadTask):Unit{
         flag01=1
    }
    public func connectTrialStart(task:DownloadTask,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
         flag02=1
    }

    public func connectTrialEnd(task:DownloadTask,responseCode:Int64,responseHeaderFields:HashMap<String, ArrayList<String>>):Unit{
         flag03=1
    }

    public func downloadFromBeginning(task:DownloadTask):Unit{
         flag04=1
    }

    public func downloadFromBreakpoint(task:DownloadTask):Unit{
         flag05=1
    }

    public func connectStart(task:DownloadTask,blockIndex:Int64,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
         flag06=1
    }

    public func connectEnd(task:DownloadTask,blockIndex:Int64,responseCode:Int64,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
         flag07=1
    }

    public func fetchStart(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit{
         flag08=1
    }

    public func fetchProgress(task:DownloadTask,blockIndex:Int64,increaseBytes:Int64):Unit{
         flag09=1
    }

    public func fetchEnd(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit{
         flag10=1
    }
    public func taskEnd(task:DownloadTask,realCause:Option<Exception>):Unit{
         flag11=1
    }
}

