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


    public init(id:Int64,url:String,parentFile:Option<Directory>,filename:String){
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

    //------


    //----
    // public func getId():Int64{
    //     return id
    // }

    public func setChunked(chunked:Bool):Unit{
        this.chunked = chunked
    }

    public func addBlock(blockInfo:BlockInfo):Unit{
        this.blockInfoList.append(blockInfo)
    }

    public func isChunked():Bool{
         return this.chunked
    }

    //------


    //------


    func isTaskOnlyProvidedParentPath():Bool{
        return taskOnlyProvidedParentPath
    }


    public func getBlock(blockIndex:Int64):Option<BlockInfo>{
        return blockInfoList.get(blockIndex)
    }

    //------


    public func resetBlockInfos():Unit{
        this.blockInfoList.clear()
    }

    public func getBlockCount():Int64{
        return blockInfoList.size
    }

    public func setEtag(etag:String):Unit{
        this.etag = etag
    }

    public func getTotalOffset():Int64{
        var offset:Int64 = 0
        for(block in blockInfoList){
            offset += block.getCurrentOffset()
        }
        return offset
    }

    public func getTotalLength():Int64{
         if (isChunked()){
            return getTotalOffset()
         }

         var length:Int64 = 0
         for(block in blockInfoList){
            length += block.getContentLength()
         }
         return length
    }

    public func getEtag():Option<String>{
        return this.etag
    }

    public func getUrl():String{
        return url
    }

    public func getFilename():Option<String>{
        return filenameHolder.get()
    }


  //------



   //------


   //------




   //------





    //------


    //------




}
