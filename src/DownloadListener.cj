package download4cj

public interface DownloadListener{

    func taskStart(task:DownloadTask):Unit

    func connectTrialStart(task:DownloadTask,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit

    func connectTrialEnd(task:DownloadTask,responseCode:Int64,responseHeaderFields:HashMap<String, ArrayList<String>>):Unit

    func downloadFromBeginning(task:DownloadTask):Unit

    func downloadFromBreakpoint(task:DownloadTask):Unit

    func connectStart(task:DownloadTask,blockIndex:Int64,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit

    func connectEnd(task:DownloadTask,blockIndex:Int64,responseCode:Int64,responseHeaderFields:HashMap<String, ArrayList<String>>):Unit

    func fetchStart(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit

    func fetchProgress(task:DownloadTask,blockIndex:Int64,increaseBytes:Int64):Unit

    func fetchEnd(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit

    func taskEnd(task:DownloadTask,realCause:Option<Exception>):Unit

}
