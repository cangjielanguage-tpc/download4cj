package okdownload

public class DefaultTransmitListener <: DownloadListener {

    var totalSize:Int64 = 0

    public func taskStart(task:DownloadTask):Unit{
        //inspectTaskStart(task)
        task.getListener().taskStart(task)
    }


    public func connectTrialStart(task:DownloadTask,headerFields:HashMap<String,ArrayList<String>>):Unit{
        task.getListener().connectTrialStart(task, headerFields)
        //Util.d("CallbackDispatcher", "-----> start trial task(" + task.getId().toString() + ")headerFields")
    }

    public func connectTrialEnd(task:DownloadTask,responseCode:Int64,headerFields:HashMap<String,ArrayList<String>>):Unit{
        task.getListener().connectTrialEnd(task, responseCode, headerFields)
        //Util.d("CallbackDispatcher", "<----- finish trial task(" + task.getId().toString()+ ") code[" + responseCode.toString() + "]headerFields")
    }


    public func downloadFromBeginning(task:DownloadTask):Unit{
         //Util.d("CallbackDispatcher", "downloadFromBeginning: " + task.getId().toString());
        task.getListener().downloadFromBeginning(task)
         //inspectDownloadFromBeginning(task, info, cause)
    }


    public func downloadFromBreakpoint(task:DownloadTask):Unit{
        //------
        task.getListener().downloadFromBreakpoint(task)
    }


     public func connectStart(task:DownloadTask,blockIndex:Int64,requestHeaderFields:HashMap<String,ArrayList<String>>):Unit{
        task.getListener().connectStart(task, blockIndex, requestHeaderFields)
        //Util.d("CallbackDispatcher", "-----> start connection task(" + task.getId().toString()+ ") block(" + blockIndex.toString() + ")requestHeaderFields")
    }


    public func connectEnd(task:DownloadTask,blockIndex:Int64,responseCode:Int64,requestHeaderFields:HashMap<String,ArrayList<String>>):Unit{
        task.getListener().connectEnd(task, blockIndex, responseCode,requestHeaderFields)
        //Util.d("CallbackDispatcher", "<----- finish connection task(" + task.getId().toString() + ") block("+ blockIndex.toString() + ") code[" + responseCode.toString() + "]requestHeaderFields")
    }


    public func fetchStart(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit{
        task.getListener().fetchStart(task, blockIndex, contentLength)
        //Util.d("CallbackDispatcher", "fetchStart: " + task.getId().toString())
    }

    public func fetchProgress(task:DownloadTask,blockIndex:Int64,increaseBytes:Int64):Unit{
        //println("increaseBytes="+increaseBytes.toString())
        task.getListener().fetchProgress(task, blockIndex, increaseBytes)
        totalSize+=increaseBytes
        //println("totalSize="+totalSize.toString())
        if (task.getMinIntervalMillisCallbackProcess() > 0) {
            TaskHideWrapper.setLastCallbackProcessTs(task,Time.now().unixNano()/1000)
        }
    }

    public func fetchEnd(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit{
        task.getListener().fetchEnd(task, blockIndex, contentLength)
        //Util.d("CallbackDispatcher", "fetchEnd: " + task.getId().toString())
    }


     public func taskEnd(task:DownloadTask,realCause:Option<Exception>):Unit{
        task.getListener().taskEnd(task,realCause)
        //------
    }








    //------



     func inspectDownloadFromBeginning(task:DownloadTask,info:BreakpointInfo,cause:ResumeFailedCause):Unit{
        //------TODO
        //let monitor:Option<DownloadMonitor> = OkDownload.withs().getMonitor()
        //------

    }


    func inspectTaskStart(task:DownloadTask):Unit{
        //------TODO
        //let monitor:Option<DownloadMonitor> = OkDownload.withs().getMonitor()
        //------

    }


    //------


}
