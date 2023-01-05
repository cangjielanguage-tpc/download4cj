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