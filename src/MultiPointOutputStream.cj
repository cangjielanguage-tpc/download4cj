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


    init(taska:DownloadTask,infoa:BreakpointInfo,storea:DownloadStore,syncRunnable:Option<()->Unit>){
        this.task = taska
        this.flushBufferSize = taska.getFlushBufferSize()
        this.syncBufferSize = taska.getSyncBufferSize()
        this.syncBufferIntervalMills = taska.getSyncBufferIntervalMills()
        this.info = infoa
        this.store = storea
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

     init(task:DownloadTask,info:BreakpointInfo,store:DownloadStore){
        this(task, info, store, Option<()->Unit>.None)
    }

     func write(blockIndex:Int64,bytes:Array<UInt8>,length:Int64){
        synchronized(m){
            if(canceled){
                return
            }
            outputStream(blockIndex).write(bytes, 0, length)
            store.onSyncToFilesystemSuccess(info,blockIndex,bytes.size)
            outputStreamMap.get(blockIndex).getOrThrow().flushAndSync()
        }
    }



    func cancelAsync():Unit{
        cancel()
    }

    func cancel():Unit{
        synchronized(m){
             if (canceled){
                return
             }
            canceled = true
            store.onTaskEnd(task.getId(), EndCause.CANCELED, Option<Exception>.None)
        }
    }



    let doneState:StreamsState = StreamsState()

     func done(blockIndex:Int64):Unit{

        close(blockIndex)
    }


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




     func setRequireStreamBlocks(requireStreamBlocks:ArrayList<Int64>):Unit{
        this.requireStreamBlocks = requireStreamBlocks
    }




    let state:StreamsState = StreamsState()


    private var firstOutputStream:Bool = true

    func outputStream(blockIndex:Int64):DownloadOutputStream{
        synchronized(m){
            var outputStream:Option<DownloadOutputStream> = outputStreamMap.get(blockIndex)
            if(let Some(i) = outputStream){
            }else{
                var uri:String
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
                        }catch(e:ReadWriteException){
                            throw ReadWriteException("Create parent folder failed!")
                        }
                    }
                    try{
                        parentFile.createFile(file.getOrThrow().info.path.fileName.getOrThrow())
                        Util.d(TAG, "Create new file: " + file.getOrThrow().info.path.fileName.getOrThrow())
                    }catch(e:Exception){
                    }
                    uri = file.getOrThrow().info.path.toString()
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




}
