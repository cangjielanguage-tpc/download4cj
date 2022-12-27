package okdownload

public class DefaultTransmitListener <: DownloadListener {

    var totalSize:Int64 = 0

    public func taskStart(task:DownloadTask):Unit{

        println("CallbackDispatcher---taskStart"+task.getId().toString())
        inspectTaskStart(task)
    }


    public func connectTrialStart(task:DownloadTask,headerFields:HashMap<String,ArrayList<String>>):Unit{
        //Util.d("CallbackDispatcher", "-----> start trial task(" + task.getId().toString() + ")headerFields")
    }

    public func connectTrialEnd(task:DownloadTask,responseCode:Int64,headerFields:HashMap<String,ArrayList<String>>):Unit{
        //Util.d("CallbackDispatcher", "<----- finish trial task(" + task.getId().toString()+ ") code[" + responseCode.toString() + "]headerFields")
    }


    public func downloadFromBeginning(task:DownloadTask,info:BreakpointInfo,cause:ResumeFailedCause):Unit{
         //Util.d("CallbackDispatcher", "downloadFromBeginning: " + task.getId().toString());
         inspectDownloadFromBeginning(task, info, cause)
    }


    public func downloadFromBreakpoint(task:DownloadTask,info:BreakpointInfo):Unit{
        //------


    }


     public func connectStart(task:DownloadTask,blockIndex:Int64,requestHeaderFields:HashMap<String,ArrayList<String>>):Unit{
        //Util.d("CallbackDispatcher", "-----> start connection task(" + task.getId().toString()+ ") block(" + blockIndex.toString() + ")requestHeaderFields")
    }


    public func connectEnd(task:DownloadTask,blockIndex:Int64,responseCode:Int64,requestHeaderFields:HashMap<String,ArrayList<String>>):Unit{
        //Util.d("CallbackDispatcher", "<----- finish connection task(" + task.getId().toString() + ") block("+ blockIndex.toString() + ") code[" + responseCode.toString() + "]requestHeaderFields")
    }


    public func fetchStart(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit{
        //Util.d("CallbackDispatcher", "fetchStart: " + task.getId().toString())
    }

    public func fetchProgress(task:DownloadTask,blockIndex:Int64,increaseBytes:Int64):Unit{
        //println("increaseBytes="+increaseBytes.toString())
        totalSize+=increaseBytes
        println("totalSize="+totalSize.toString())
        if (task.getMinIntervalMillisCallbackProcess() > 0) {
            TaskHideWrapper.setLastCallbackProcessTs(task,Time.now().unixNano()/1000)
        }
    }

    public func fetchEnd(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit{
        //Util.d("CallbackDispatcher", "fetchEnd: " + task.getId().toString())
    }


     public func taskEnd(task:DownloadTask,cause:EndCause,realCause:Option<Exception>):Unit{

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
