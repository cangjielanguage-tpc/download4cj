package okdownload

public class DefaultTransmitListener <: DownloadListener {

    var totalSize:Int64 = 0

    public func taskStart(task:DownloadTask):Unit{
        task.getListener().taskStart(task)
    }

    public func connectTrialStart(task:DownloadTask,headerFields:HashMap<String,ArrayList<String>>):Unit{
        task.getListener().connectTrialStart(task, headerFields)
    }

    public func connectTrialEnd(task:DownloadTask,responseCode:Int64,headerFields:HashMap<String,ArrayList<String>>):Unit{
        task.getListener().connectTrialEnd(task, responseCode, headerFields)
    }

    public func downloadFromBeginning(task:DownloadTask):Unit{
        task.getListener().downloadFromBeginning(task)
    }

    public func downloadFromBreakpoint(task:DownloadTask):Unit{
        task.getListener().downloadFromBreakpoint(task)
    }

    public func connectStart(task:DownloadTask,blockIndex:Int64,requestHeaderFields:HashMap<String,ArrayList<String>>):Unit{
        task.getListener().connectStart(task, blockIndex, requestHeaderFields)
    }

    public func connectEnd(task:DownloadTask,blockIndex:Int64,responseCode:Int64,requestHeaderFields:HashMap<String,ArrayList<String>>):Unit{
        task.getListener().connectEnd(task, blockIndex, responseCode,requestHeaderFields)
    }

    public func fetchStart(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit{
        task.getListener().fetchStart(task, blockIndex, contentLength)
    }

    public func fetchProgress(task:DownloadTask,blockIndex:Int64,increaseBytes:Int64):Unit{
        task.getListener().fetchProgress(task, blockIndex, increaseBytes)
        totalSize+=increaseBytes
        if (task.getMinIntervalMillisCallbackProcess() > 0) {
            TaskHideWrapper.setLastCallbackProcessTs(task,Time.now().unixTimeStamp().nanoseconds()/1000)
        }
    }

    public func fetchEnd(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit{
        task.getListener().fetchEnd(task, blockIndex, contentLength)
    }

    public func taskEnd(task:DownloadTask,realCause:Option<Exception>):Unit{
        task.getListener().taskEnd(task,realCause)
    }

}
