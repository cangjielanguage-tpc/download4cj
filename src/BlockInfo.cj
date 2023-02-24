package okdownload

public class BlockInfo {
    //
    private let startOffset:Int64
    private let contentLength:Int64
    private let currentOffset:AtomicInt64

    init(startOffset:Int64,contentLength:Int64){
        this(startOffset, contentLength, 0)
    }

    init(startOffset:Int64,contentLength:Int64,currentOffset:Int64){
        this.startOffset = startOffset
        this.contentLength = contentLength
        this.currentOffset =  AtomicInt64(currentOffset)
    }

    func getCurrentOffset():Int64{
        return this.currentOffset.load()
    }

    func getRangeLeft():Int64{
        return startOffset + currentOffset.load()
    }

    func getContentLength():Int64{
        return contentLength
    }

    func getRangeRight():Int64{
        return startOffset + contentLength - 1
    }

    func resetBlock():Unit{
        this.currentOffset.store(0)
    }

    func increaseCurrentOffset(increaseLength:Int64):Unit{
        this.currentOffset.fetchAdd(increaseLength)
    }

}
