package okdownload

public interface DownloadStore <: BreakpointStore {

    func onSyncToFilesystemSuccess(info:BreakpointInfo,blockIndex:Int64,increaseLength:Int64):Unit

    func onTaskStart(id:Int64):Unit

    func onTaskEnd(id:Int64,cause:EndCause,exception:Option<Exception>):Unit

    func getAfterCompleted(id:Int64):Option<BreakpointInfo>

    func markFileDirty(id:Int64):Bool

    func markFileClear(id:Int64):Bool

}
