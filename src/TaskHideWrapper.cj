/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights resvered.
 */

package download4cj

public class TaskHideWrapper {

     static func getLastCallbackProcessTs(task:DownloadTask):Int64{
        return task.getLastCallbackProcessTs()
    }

     static func setLastCallbackProcessTs(task:DownloadTask,lastCallbackProcessTimestamp:Int64):Unit{
        task.setLastCallbackProcessTs(lastCallbackProcessTimestamp)
    }

     static func setBreakpointInfo(task:DownloadTask,info:BreakpointInfo):Unit{
        task.setBreakpointInfo(info);
    }
}
