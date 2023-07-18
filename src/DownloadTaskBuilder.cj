package download4cj

public class DownloadTaskBuilder{

    let m:MultiConditionMonitor = MultiConditionMonitor()


    let url:String
    let uri:String
    private var headerMapFields:Option<HashMap<String, ArrayList<String>>> = HashMap<String, ArrayList<String>>()

    private var isFilenameFromResponse:Bool
    private var filename:String
    private var connectionCount:Int64
    private var isPreAllocateLength:Option<Bool>

    private var priority:Int64
     static let DEFAULT_READ_BUFFER_SIZE:Int64 = 4096
    private var readBufferSize:Int64 = DEFAULT_READ_BUFFER_SIZE
     static let DEFAULT_FLUSH_BUFFER_SIZE:Int64 = 16384
    private var flushBufferSize:Int64 = DEFAULT_FLUSH_BUFFER_SIZE

     static let DEFAULT_SYNC_BUFFER_SIZE:Int64 = 65536
    private var syncBufferSize:Int64 = DEFAULT_SYNC_BUFFER_SIZE
     static let DEFAULT_SYNC_BUFFER_INTERVAL_MILLIS:Int64 = 2000
    private var syncBufferIntervalMillis:Int64 = DEFAULT_SYNC_BUFFER_INTERVAL_MILLIS

     static let DEFAULT_AUTO_CALLBACK_TO_UI_THREAD:Bool = true
    private var autoCallbackToUIThread:Bool = DEFAULT_AUTO_CALLBACK_TO_UI_THREAD

     static let DEFAULT_MIN_INTERVAL_MILLIS_CALLBACK_PROCESS:Int64 = 3000
    private var minIntervalMillisCallbackProcess:Int64 = DEFAULT_MIN_INTERVAL_MILLIS_CALLBACK_PROCESS

     static let DEFAULT_PASS_IF_ALREADY_COMPLETED:Bool = true
    private var passIfAlreadyCompleted :Bool = DEFAULT_PASS_IF_ALREADY_COMPLETED
     static let DEFAULT_IS_WIFI_REQUIRED:Bool = false
    private var isWifiRequired :Bool = DEFAULT_IS_WIFI_REQUIRED



    public init(url:String,file:Directory){
        this.url = url
        this.uri = file.info.path.toString()
        this.isFilenameFromResponse = false
        this.filename = ""
        this.connectionCount = 0
        this.isPreAllocateLength = Option<Bool>.None
        this.priority = 0

    }


    public func setMinIntervalMillisCallbackProcess(minIntervalMillisCallbackProcess:Int64):DownloadTaskBuilder{
        if(minIntervalMillisCallbackProcess < 0){
            throw IllegalArgumentException("Value must be positive!")
        }
        this.minIntervalMillisCallbackProcess = minIntervalMillisCallbackProcess
        return this
    }




    public func setReadBufferSize(readBufferSize:Int64):DownloadTaskBuilder{
        if (readBufferSize <= 0){
            throw IllegalArgumentException("Value must be positive!")
        }
        this.readBufferSize = readBufferSize
        return this
    }



     public func setFlushBufferSize(flushBufferSize:Int64):DownloadTaskBuilder{
        if (flushBufferSize <= 0){
            throw IllegalArgumentException("Value must be positive!")
        }
        this.flushBufferSize = flushBufferSize
        return this
    }


    public func setFilename(filename:String):DownloadTaskBuilder{
        this.filename = filename
        return this
    }


    public func build():DownloadTask{
         return  DownloadTask(url, uri, priority, readBufferSize, flushBufferSize,syncBufferSize, syncBufferIntervalMillis,autoCallbackToUIThread, minIntervalMillisCallbackProcess,headerMapFields.getOrThrow(), filename, passIfAlreadyCompleted, isWifiRequired,isFilenameFromResponse, connectionCount, isPreAllocateLength)
    }
}
