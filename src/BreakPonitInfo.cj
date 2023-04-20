package okdownload

public class BreakpointInfo {

    let id:Int64
    private let url:String
    private var etag:Option<String>

    let parentFile:Option<Directory>
    private var targetFile:Option<File>
    private let filenameHolder:FileNameHolder

    private let blockInfoList:ArrayList<BlockInfo>
    private let taskOnlyProvidedParentPath:Bool
    private var chunked:Bool = false

    init(id:Int64,url:String,parentFile:Option<Directory>,filename:String){
        this.id = id
        this.url = url
        this.parentFile = parentFile
        this.blockInfoList = ArrayList<BlockInfo>()
        this.targetFile = Option<File>.None
        if(filename.isEmpty()){
             filenameHolder = FileNameHolder()
             taskOnlyProvidedParentPath = true
        }else{
            filenameHolder = FileNameHolder(filename)
            taskOnlyProvidedParentPath = false
            let filePath:Path = parentFile.getOrThrow().info.path.join(filename)
            this.targetFile = File.openRead(filePath)
        }
        etag = ""
    }

    func getId():Int64{
        return id
    }

    func setChunked(chunked:Bool):Unit{
        this.chunked = chunked
    }

    func addBlock(blockInfo:BlockInfo):Unit{
        this.blockInfoList.append(blockInfo)
    }

    func isChunked():Bool{
         return this.chunked
    }

    func isTaskOnlyProvidedParentPath():Bool{
        return taskOnlyProvidedParentPath
    }

    func getBlock(blockIndex:Int64):Option<BlockInfo>{
        return blockInfoList.get(blockIndex)
    }

    func getBlockInfoList():ArrayList<BlockInfo>{
        return blockInfoList
    }

    func resetBlockInfos():Unit{
        this.blockInfoList.clear()
    }

    func getBlockCount():Int64{
        return blockInfoList.size
    }

    func setEtag(etag:String):Unit{
        this.etag = etag
    }

    func getTotalOffset():Int64{
        var offset:Int64 = 0
        for(block in blockInfoList){
            offset += block.getCurrentOffset()
        }
        return offset
    }

    func getTotalLength():Int64{
         if (isChunked()){
            return getTotalOffset()
         }

         var length:Int64 = 0
         for(block in blockInfoList){
            length += block.getContentLength()
         }
         return length
    }

    func getEtag():Option<String>{
        return this.etag
    }

    func getUrl():String{
        return url
    }

    func getFilename():Option<String>{
        return filenameHolder.get()
    }

    func isSameFrom(task:DownloadTask):Bool{
        if(!parentFile.getOrThrow().info.path.toString().equals(task.getParentFile().info.path.toString())){
            return false
        }
        if(!url.equals(task.getUrl())){
            return false
        }
        let otherFilename:Option<String> = task.getFilename()
        if(let Some(i) = otherFilename){
            if(i.equals(filenameHolder.get().getOrThrow())){
                return true
            }
        }
        return false
    }
}
