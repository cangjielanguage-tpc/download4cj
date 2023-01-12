package okdownload

public class TaskHideWrapper {

    public static func getLastCallbackProcessTs(task:DownloadTask):Int64{
        return task.getLastCallbackProcessTs()
    }

    public static func setLastCallbackProcessTs(task:DownloadTask,lastCallbackProcessTimestamp:Int64):Unit{
        task.setLastCallbackProcessTs(lastCallbackProcessTimestamp)
    }

    public static func setBreakpointInfo(task:DownloadTask,info:BreakpointInfo):Unit{
        task.setBreakpointInfo(info);
    }
}
