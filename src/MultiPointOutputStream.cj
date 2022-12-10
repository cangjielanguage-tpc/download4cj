package okdownload

public class MultiPointOutputStream {


    let m:MultiConditionMonitor = MultiConditionMonitor()
    let m1:MultiConditionMonitor = MultiConditionMonitor()
    let m2:MultiConditionMonitor = MultiConditionMonitor()



    private static let TAG:String = "MultiPointOutputStream"
    let outputStreamMap:HashMap<Int64,DownloadOutputStream> = HashMap<Int64,DownloadOutputStream>()
    let noSyncLengthMap:HashMap<Int64,AtomicInt64> = HashMap<Int64,AtomicInt64>()
    let allNoSyncLength:AtomicInt64 = AtomicInt64(0)
    let lastSyncTimestamp:AtomicInt64 = AtomicInt64(0)
    var canceled:Bool = false

    private let flushBufferSize:Int64
    private let syncBufferSize:Int64
    private let syncBufferIntervalMills:Int64
    private let info:BreakpointInfo
    private let task:DownloadTask
    private let store:DownloadStore
    private let supportSeek:Bool
    private let isPreAllocateLength:Bool


    var syncFuture:Option<Future<Unit>> = Option<Future<Unit>>.None
    private var syncRunnable:Option<()->Unit> = Option<()->Unit>.None

    // volatile Thread runSyncThread;
    let parkedRunBlockThreadMap:HashMap<Int64,ConditionID>  = HashMap<Int64,ConditionID>()
    private var syncConditionId:Option<ConditionID> = Option<ConditionID>.None

    // @NonNull private final Runnable syncRunnable;
    private var path:Option<String>
    var syncException:Option<IOException> = Option<IOException>.None
    var noMoreStreamList:ArrayList<Int64>
    var requireStreamBlocks:Option<ArrayList<Int64>>


    init(task:DownloadTask,info:BreakpointInfo,store:DownloadStore,syncRunnable:Option<()->Unit>){
        this.task = task
        this.flushBufferSize = task.getFlushBufferSize()
        this.syncBufferSize = task.getSyncBufferSize()
        this.syncBufferIntervalMills = task.getSyncBufferIntervalMills()
        this.info = info
        this.store = store
        this.supportSeek = OkDownload.withs().outputStreamFactory().supportSeek()
        this.isPreAllocateLength = OkDownload.withs().processFileStrategy().isPreAllocateLength(task)
        this.noMoreStreamList = ArrayList<Int64>()
        this.requireStreamBlocks = ArrayList<Int64>()
        this.syncRunnable = syncRunnable
        let file:Option<File> = task.getFile()
        if(let Some(i) = file){
            this.path = i.info.path.toString()
        }else{
            this.path = ""
        }
    }

    public init(task:DownloadTask,info:BreakpointInfo,store:DownloadStore){
        this(task, info, store, Option<()->Unit>.None)
    }

    public func write(blockIndex:Int64,bytes:Array<UInt8>,length:Int64){
        synchronized(m){
            if(canceled){
                return
            }
            //println("mult0000")
            outputStream(blockIndex).write(bytes, 0, length)
            //println("mult00014")
            outputStreamMap.get(blockIndex).getOrThrow().flushAndSync()
            //allNoSyncLength.fetchAdd(length)
            //noSyncLengthMap.get(blockIndex).getOrThrow().fetchAdd(length)
            //println("mult00015")
            //inspectAndPersist()
        }
    }


    //------





    //------


    let doneState:StreamsState = StreamsState()

    public func done(blockIndex:Int64):Unit{
        //------

        close(blockIndex)
    }

    //------





    public func inspectComplete(blockIndex:Int64):Unit{
        let blockInfo:Option<BlockInfo> =  info.getBlock(blockIndex)
        // if (!Util.isCorrectFull(blockInfo.getOrThrow().getCurrentOffset(), blockInfo.getOrThrow().getContentLength())) {
        //     throw IOException("The current offset on block-info isn't update correct, "+ blockInfo.getOrThrow().getCurrentOffset().toString() + " != " + blockInfo.getOrThrow().getContentLength().toString()+ " on " + blockIndex.toString())
        // }
    }

    //------



    func close(blockIndex:Int64):Unit{
        synchronized(m){
            let outputStream:Option<DownloadOutputStream> = outputStreamMap.get(blockIndex)
                if(let Some(i) = outputStream){
                outputStream.getOrThrow().close()
                outputStreamMap.remove(blockIndex)
                Util.d(TAG, "OutputStream close task[" + task.getId().toString() + "] block[" + blockIndex.toString() + "]")
            }
        }
    }

    //------



    public func setRequireStreamBlocks(requireStreamBlocks:ArrayList<Int64>):Unit{
        this.requireStreamBlocks = requireStreamBlocks
    }


    public func catchBlockConnectException(blockIndex:Int64){
        noMoreStreamList.append(blockIndex)
    }


    let state:StreamsState = StreamsState()

    //------




    //------



    //------


    //------


    //------



    func flushProcess():Unit{
        //------

    }

    private var firstOutputStream:Bool = true

    func outputStream(blockIndex:Int64):DownloadOutputStream{
        synchronized(m){
            var outputStream:Option<DownloadOutputStream> = outputStreamMap.get(blockIndex)
            if(let Some(i) = outputStream){
                //非空
            }else{
                var uri:URL
                let isFileScheme:Bool = Util.isUriFileScheme(task.getUri())
                if(!isFileScheme){
                    let file:Option<File> = task.getFile()
                    if(let Some(j) = file){
                    }else{
                        throw FileNotFoundException("Filename is not ready!")
                    }

                    let parentFile:Directory = task.getParentFile()
                    if(!Directory.exists(parentFile.info.path)){
                        try{
                            Directory.create(parentFile.info.path)
                        }catch(e:IOException){
                            throw IOException("Create parent folder failed!")
                        }
                    }
                    try{
                        //File.create(file.getOrThrow().info.path)
                        parentFile.createFile(file.getOrThrow().info.path.fileName.getOrThrow())
                        Util.d(TAG, "Create new file: " + file.getOrThrow().info.path.fileName.getOrThrow())
                    }catch(e:Exception){

                    }
                    uri = URL.parse(file.getOrThrow().info.path.toString())
                }else{
                    uri = task.getUri()
                }
                outputStream = OkDownload.withs().outputStreamFactory().create(uri,flushBufferSize)
                if(supportSeek){
                    let seekPoint:Int64 = info.getBlock(blockIndex).getOrThrow().getRangeLeft()
                    if (seekPoint > 0){
                        // seek to target point
                        outputStream.getOrThrow().seek(seekPoint)
                        Util.d(TAG, "Create output stream write from (" + task.getId().toString()+ ") block(" + blockIndex.toString() + ") " + seekPoint.toString())
                    }else{
                    }
                }

                if (firstOutputStream) {
                    store.markFileDirty(task.getId())
                }
                if (!info.isChunked() && firstOutputStream && isPreAllocateLength) {
                    // pre allocate length
                    let totalLength:Int64 = info.getTotalLength()
                    if (!isFileScheme) {
                        let file:Option<File> = task.getFile()
                        let requireSpace:Int64 = totalLength - file.getOrThrow().info.length
                        if (requireSpace > 0) {
                            outputStream.getOrThrow().setLength(totalLength)
                        }
                    } else {
                        outputStream.getOrThrow().setLength(totalLength)
                    }
                }
                synchronized (m2) {
                    // make sure the length of noSyncLengthMap is equal to outputStreamMap
                    outputStreamMap.put(blockIndex, outputStream.getOrThrow())
                    noSyncLengthMap.put(blockIndex, AtomicInt64(0))
                }
                firstOutputStream = false
            }
            return outputStream.getOrThrow()
        }
    }


    //------


}
