package download4cj

public interface BreakpointStore{

    func get(id:Int64):Option<BreakpointInfo>

    func createAndInsert(task:DownloadTask):BreakpointInfo

    func findOrCreateId(task:DownloadTask):Int64

    func update(breakpointInfo:BreakpointInfo):Bool

    func remove(id:Int64):Unit

    func findAnotherInfoFromCompare(task:DownloadTask,ignored:BreakpointInfo):Option<BreakpointInfo>

    func isOnlyMemoryCache():Bool

}
