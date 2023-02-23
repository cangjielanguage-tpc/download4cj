package okdownload


from std import fs.*
from encoding import url.*
from std import collection.*
from std import io.*
from std import sync.*
from std import log.*
from std import socket.*
from std import time.*


public class DownloadTask <: IdentifiedTask & Hashable & Equatable<DownloadTask>{

    let m:MultiConditionMonitor = MultiConditionMonitor()


    private var id:Int64 //下载任务唯一id
    private let url:String  //下载url
    private let uri:URL ////下载url
    private let headerMapFields:HashMap<String, ArrayList<String>> //头信息

    private var info:Option<BreakpointInfo> //断点信息
    private let priority:Int64  //优先级
    private let readBufferSize:Int64 // 读取缓冲区大小
    private let flushBufferSize:Int64 // 刷新缓冲区大小
    private let syncBufferSize:Int64 // 同步缓冲区大小
    private let syncBufferIntervalMills:Int64 // 同步缓冲间隔毫米
    private let connectionCount:Int64 // 连接数
    private let isPreAllocateLength:Option<Bool> // 是预分配长度
    private let passIfAlreadyCompleted:Bool // 成功完成
    private let autoCallbackToUIThread:Bool // 自动回调到UIThread
    private let minIntervalMillisCallbackProcess:Int64 // 最小间隔Millis回调进程
    private var listener: Option<DownloadListener>  //下载监听
    private var keyTagMap: Option<HashMap<Int64,Object>> //Tag集合
    private var tag:Option<Object>
    private let wifiRequired:Bool //需要wifi
    private let lastCallbackProcessTimestamp:AtomicInt64 //上次回调处理时间戳
    private var filenameFromResponse:Bool //文件名来自响应
    var filenameHolder:FileNameHolder
    var providedPathFile:Option<File> //提供的路径文件
    var directoryFile :Directory
    var targetFile :Option<File>
    private var redirectLocation : String
    private var filename:Option<String>

    public DownloadTask(urla:String,uria:URL,prioritya:Int64,readBufferSizea:Int64,flushBufferSizea:Int64,syncBufferSizea:Int64,
    syncBufferIntervalMillsa:Int64,autoCallbackToUIThreada:Bool,minIntervalMillisCallbackProcessa:Int64,
    headerMapFieldsa:HashMap<String, ArrayList<String>>,filename:Option<String>,passIfAlreadyCompleted:Bool,wifiRequired:Bool,
    filenameFromResponses:Option<Bool>,connectionCount:Int64,isPreAllocateLength:Option<Bool>){
        this.id = 0
        this.url = urla
        this.uri = uria
        this.priority = prioritya
        this.readBufferSize = readBufferSizea
        this.flushBufferSize = flushBufferSizea
        this.syncBufferSize = syncBufferSizea
        this.syncBufferIntervalMills = syncBufferIntervalMillsa
        this.autoCallbackToUIThread = autoCallbackToUIThreada
        this.minIntervalMillisCallbackProcess = minIntervalMillisCallbackProcessa
        this.headerMapFields = headerMapFieldsa
        this.lastCallbackProcessTimestamp = AtomicInt64(0)
        this.passIfAlreadyCompleted = passIfAlreadyCompleted;
        this.wifiRequired = wifiRequired
        this.connectionCount = connectionCount
        this.isPreAllocateLength = isPreAllocateLength
        this.filename = filename
        this.filenameFromResponse = filenameFromResponses.getOrThrow()
        this.info = Option<BreakpointInfo>.None
        this.listener = Option<DownloadListener>.None
        this.keyTagMap = Option<HashMap<Int64,Object>>.None
        this.tag = Option<Object>.None
        this.redirectLocation = ""

        let dirFile:Directory = Directory(uria.path)
        filenameFromResponse = true
        directoryFile = dirFile
        this.filenameFromResponse = filenameFromResponse

        if(Util.isEmpty(this.filename.getOrThrow())){
            //如果没设置名字，名字就从url里取
            // let lastIndex:Int64 = urla.lastIndexOf("/").getOrThrow()
            // this.filename = urla.substring(lastIndex+1)
            filenameHolder = FileNameHolder("")
            targetFile = Option<File>.None
            providedPathFile = Option<File>.None
        }else{
            filenameHolder = FileNameHolder(this.filename.getOrThrow())
            targetFile = directoryFile.createFile(this.filename.getOrThrow())
            providedPathFile = targetFile.getOrThrow()
        }



        this.id = OkDownload.withs().breakpointStore().findOrCreateId(this)

    }


    func isFilenameFromResponse():Bool{
        return filenameFromResponse
    }

    func getHeaderMapFields():Option<HashMap<String, ArrayList<String>>>{
        return headerMapFields
    }

    public func getId():Int64{
        return id
    }

    public func getFilename():Option<String>{
        return filenameHolder.get()
    }

    func isPassIfAlreadyCompleted():Bool{
        return passIfAlreadyCompleted
    }


    public func getUri():URL{
        return uri
    }

    public func getUrl():String{
        return url
    }


     func setRedirectLocation(redirectUrl:String){
        this.redirectLocation = redirectUrl
    }

     func getRedirectLocation():String{
        return redirectLocation
    }

    public func getProvidedPathFile():Option<File>{
        return  providedPathFile
    }

    func getParentFile():Directory{
        return directoryFile
    }

     func getFile():Option<File>{
        let filenames:Option<String> = filenameHolder.get()
        if(let Some(i) = filenames){

        }else{
            return Option<File>.None
        }

        if(let Some(i) = targetFile){

        }else{
            targetFile = File(directoryFile.info.path.toString()+filenames.getOrThrow(),OpenOption.Open(true,true)); //targetFile就是下载的目标文件
        }
        return targetFile
    }


    public func getReadBufferSize():Int64{
        return readBufferSize
    }

    public func getFlushBufferSize():Int64{
        return flushBufferSize
    }

     func getSyncBufferSize():Int64{
        return syncBufferSize
    }

     func getSyncBufferIntervalMills():Int64{
        return syncBufferIntervalMills
    }



   public func getMinIntervalMillisCallbackProcess():Int64{
        return minIntervalMillisCallbackProcess
    }

    func getSetConnectionCount():Option<Int64>{
        return connectionCount
    }

     func getSetPreAllocateLength():Option<Bool>{
        return isPreAllocateLength
    }

    public func getConnectionCount():Int64{
        if(let Some(i) = info){
            return i.getBlockCount();
        }else{
            return 0
        }
    }


    func getLastCallbackProcessTs():Int64{
        return lastCallbackProcessTimestamp.load()
    }

    func setLastCallbackProcessTs(lastCallbackProcessTimestamp:Int64):Unit{
        this.lastCallbackProcessTimestamp.store(lastCallbackProcessTimestamp);
    }

    func setBreakpointInfo(info:BreakpointInfo):Unit{
        this.info = info
    }



     public static func enqueues(tasks:Array<DownloadTask>,listener:DownloadListener):Unit{
        for(task in tasks){
            task.listener = listener
        }
        OkDownload.withs().downloadDispatcher().enqueue(tasks)
    }


    public func enqueue(listener:DownloadListener):Unit{
        this.listener = listener
        OkDownload.withs().downloadDispatcher().enqueue(this)
    }


    public func execute(listener:DownloadListener):Unit{
        this.listener = listener
        OkDownload.withs().downloadDispatcher().execute(this)
    }



    func getListener():DownloadListener{
        return this.listener.getOrThrow()
    }

    func getPriority():Int64{
        return priority
    }




    public operator func ==(anothor: DownloadTask): Bool{

        return true
    }


    public operator func !=(anothor: DownloadTask): Bool{

        return false
    }


    public func hashCode(): Int64{
        return (url + providedPathFile.getOrThrow().info.path.toString() + filenameHolder.get().getOrThrow()).hashCode();
    }


    public func toString():String{
        return  id.toString() + "@" + url + "@" + directoryFile.info.path.toString()+ "/" + filenameHolder.get().getOrThrow()
    }



    public func mock(id:Int64):MockTaskForCompare{
        return MockTaskForCompare(id, this)
    }

}
