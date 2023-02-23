# okdownload

## 描述
可靠、灵活、快速和强大的下载引擎。

## 类描述

### class DownloadTaskBuilder

```cangjie
public class DownloadTaskBuilder{

    /* 用于构造DownloadTaskBuilder对象
     *
     * 参数 String类型 要下载的文件的url
     * 参数 Directory类型 把下载下来的文件放到哪个目录下
     */
    public init(url:String,file:Directory){

    /* 用于设置下载文件的名称
     *
     * 参数 String类型 设置给下载下来的文件的名字
     * 返回值 DownloadTaskBuilder类型 构建DownloadTask的构建类
     */
    public func setFilename(filename:String):DownloadTaskBuilder{

    /* 设置进度回调的时间间隔
     *
     * 参数 Int64类型 下载的时候多少毫秒进行一次回调
     * 返回值 DownloadTaskBuilder类型 构建DownloadTask的构建类
     */
    public func setMinIntervalMillisCallbackProcess(minIntervalMillisCallbackProcess:Int64):DownloadTaskBuilder{

    /* 设置读取缓存大小
     *
     * 参数 Int64类型 下载的时候的读取缓冲的大小
     * 返回值 DownloadTaskBuilder类型 构建DownloadTask的构建类
     */
    public func setReadBufferSize(readBufferSize:Int64):DownloadTaskBuilder{

    /* 设置刷新缓冲大小
     *
     * 参数 Int64类型 刷缓冲的大小
     * 返回值 DownloadTaskBuilder类型 构建DownloadTask的构建类
     */
    public func setFlushBufferSize(flushBufferSize:Int64):DownloadTaskBuilder{

    /* 用于构造DownloadTask对象
     *
     * 返回值 DownloadTask类型 构建的DownloadTask对象
     */
    public func build():DownloadTask{

}
```

### class DownloadTask

```cangjie
public class DownloadTask{

    /* 用于执行同步下载
     *
     * 参数 DownloadListener类型 下载的时候的监听类
     */
    public func execute(listener:DownloadListener){

    /* 用于执行异步下载
     *
     * 参数 DownloadListener类型 下载的时候的监听类
     */
    public func enqueue(listener:DownloadListener){

    /* 用于执行异步下载多个任务
     *
     * 参数 Array<DownloadTask>类型 要下载的任务的数组
     * 参数 DownloadListener类型 下载的时候的监听类
     */
    public static func enqueues(tasks:Array<DownloadTask>,listener:DownloadListener){

    /* 获取任务的Id
     *
     * 返回值 Int64类型 任务的id
     */
    public func getId():Int64{

    /* 获取文件名
     *
     * 返回值 Option<String>类型 获得文件的名字
     */
    public func getFilename():Option<String>{

    /* 获取文件下载路径
     *
     * 返回值 String类型 获取文件的下载url路径
     */
    public func getUrl():String{

    /* 获取下载下来的文件的父文件夹
     *
     * 返回值 URL类型 文件的文件夹对应的URL
     */
    public func getUri():URL{

    /* 获取下载后的文件
     *
     * 返回值 File类型 下载后的文件对象
     */
    public func getProvidedPathFile():File{

    /* 获取读取文件的缓存大小
     *
     * 返回值 Int64类型 获取下载时候的读取缓冲大小
     */
    public func getReadBufferSize():Int64{

    /* 获取刷新的缓冲大小
     *
     * 返回值 Int64类型 获取下载写入时候的冲刷缓冲大小
     */
    public func getFlushBufferSize():Int64{

    /*获取回调时间间隔数
     *
     * 返回值 Int64类型  下载进度回调的时间间隔数，单位毫秒
     */
    public func getMinIntervalMillisCallbackProcess():Int64{

    /* 获取下载时候的连接数
     *
     * 返回值Int64类型,获取下载连接数
     */
    public func getConnectionCount():Int64{

}
```

### interface DownloadListener


```cangjie
public interface DownloadListener{

    /* 任务刚开始的回调
     *
     * 参数 DownloadTask类型 下载的任务对象
     */
    func taskStart(task:DownloadTask)

    /* 任务开始尝试连接的回调
     *
     * 参数 DownloadTask类型 下载的任务对象
     * 参数 HashMap<String, ArrayList<String>>类型 请求的header
     */
    func connectTrialStart(task:DownloadTask,requestHeaderFields:HashMap<String, ArrayList<String>>)

    /* 任务结束尝试连接的回调
     *
     * 参数 DownloadTask类型 下载的任务对象
     * 参数 Int64类型 请求返回的响应码
     * 参数 HashMap<String, ArrayList<String>>类型 响应的haeder
     */
    func connectTrialEnd(task:DownloadTask,responseCode:Int64,responseHeaderFields:HashMap<String, ArrayList<String>>)

    /* 从开始下载的回调
     *
     * 参数 DownloadTask类型 下载的任务对象
     */
    func downloadFromBeginning(task:DownloadTask)

    /* 从断点处下载的回调
     *
     * 参数 DownloadTask类型 下载的任务对象
     */
    func downloadFromBreakpoint(task:DownloadTask)

    /* 连接开始的回调
     *
     * 参数 DownloadTask类型 下载的任务对象
     * 参数 Int64类型 对应的分块index
     * 参数 HashMap<String, ArrayList<String>>类型 请求的请求头
     */
    func connectStart(task:DownloadTask,blockIndex:Int64,requestHeaderFields:HashMap<String, ArrayList<String>>)

    /* 连接结束的回调
     *
     * 参数 DownloadTask类型 下载的任务对象
     * 参数 Int64类型 对应的分块index
     * 参数 Int64类型 请求返回的响应码
     * 参数 HashMap<String, ArrayList<String>>类型 响应的haeder
     */
    func connectEnd(task:DownloadTask,blockIndex:Int64,responseCode:Int64,responseHeaderFields:HashMap<String, ArrayList<String>>)

    /* 开始获取进度的回调
     *
     * 参数 DownloadTask类型 下载的任务对象
     * 参数 Int64类型 对应的分块index
     * 参数 Int64类型 下载的内容长度
     */
    func fetchStart(task:DownloadTask,blockIndex:Int64,contentLength:Int64)

    /* 获取进度的回调
     *
     * 参数 DownloadTask类型 下载的任务对象
     * 参数 Int64类型 对应的分块index
     * 参数 Int64类型 下载增加的部分字节数
     */
    func fetchProgress(task:DownloadTask,blockIndex:Int64,increaseBytes:Int64)

    /* 获取进度结束的回调
     *
     * 参数 DownloadTask类型 下载的任务对象
     * 参数 Int64类型 对应的分块index
     * 参数 Int64类型 下载的内容长度
     */
    func fetchEnd(task:DownloadTask,blockIndex:Int64,contentLength:Int64)

    /* 任务结束的回调
     *
     * 参数 DownloadTask类型 下载的任务对象
     * 参数 Option<Exception>类型 造成异常结束的原因
     */
    func taskEnd(task:DownloadTask,realCause:Option<Exception>)

}
```

##  展示示例

####  同步下载

```

// EXEC: cjc %import-path %L %l %f
// EXEC: ./main


// EXEC: cjc %import-path %L %l %f
// EXEC: ./main


from okdownload import okdownload.*
from std import collection.*
from std import fs.*


var isComplete = false

//目的 主要为了验证同步下载

main(){

        var url:String = "https://www.voidtools.com/Everything-1.4.1.1017.x64-Setup.exe"

        let parentFilePath:Path = Path("./fileDownLoad")
        var parentFile:Option<Directory> = Option<Directory>.None

        if (!Directory.exists(parentFilePath)) {
            parentFile = Directory.create(parentFilePath, recursive: true)
        }else{
        }

        let task:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
            .setMinIntervalMillisCallbackProcess(30)
            .build()
        task.execute(MyListen())
        if(isComplete){
            return 0
        }else{
            return 1
        }

}

public class MyListen<: DownloadListener{

    public func taskStart(task:DownloadTask):Unit{
    }

    public func connectTrialStart(task:DownloadTask,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
    }

    public func connectTrialEnd(task:DownloadTask,responseCode:Int64,responseHeaderFields:HashMap<String, ArrayList<String>>):Unit{
    }

    public func downloadFromBeginning(task:DownloadTask):Unit{
    }

    public func downloadFromBreakpoint(task:DownloadTask):Unit{
    }

    public func connectStart(task:DownloadTask,blockIndex:Int64,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
    }

    public func connectEnd(task:DownloadTask,blockIndex:Int64,responseCode:Int64,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
    }

    public func fetchStart(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit{
    }

    public func fetchProgress(task:DownloadTask,blockIndex:Int64,increaseBytes:Int64):Unit{
    }

    public func fetchEnd(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit{
    }

    public func taskEnd(task:DownloadTask,realCause:Option<Exception>):Unit{
        isComplete = true
    }
}

```

```cangjie

[02-15 21:50:10] INFO - FILE   : maintest01.cj
[02-15 21:50:13] INFO - CMD    : ./main
[02-15 21:50:13] INFO - FILE   : maintest01.cj
[02-15 21:50:57] INFO - return : 0
[02-15 21:50:57] INFO -  >>=============================================<<
[02-15 21:50:57] INFO -
[02-15 21:50:57] INFO -
[02-15 21:50:57] INFO -
[02-15 21:50:57] INFO -   TestSuiteTask: Total: 1, PASS: 1, FAIL: 0

```

####  异步下载

```

// EXEC: cjc %import-path %L %l %f
// EXEC: ./main


from okdownload import okdownload.*
from std import collection.*
from std import fs.*

//目的 主要为了验证异步下载单个


var isComplete = false


main(){

    var url:String = "http://imgsrc.baidu.com/forum/w%3D580/sign=eed1753686d6277fe9123230183a1f63/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"
    let lastIndex:Int64 = url.lastIndexOf(".").getOrThrow()
    var FileEnds = url.substring(lastIndex)

    let filenamePre:String = "single-test"
    let filename = filenamePre+FileEnds

    let parentFilePath:Path = Path("./fileDownLoad0")
    var parentFile:Option<Directory> = Option<Directory>.None

    if (!Directory.exists(parentFilePath)) {
        parentFile = Directory.create(parentFilePath, recursive: true)
    }else{
    }

    let task:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
         .setFilename(filename)
         .setMinIntervalMillisCallbackProcess(30)
         .build()

     task.enqueue(MyListen())
     sleep(1000*1000*1000*3)
     if(isComplete){
        return 0
     }else{
        return 1
     }
}


public class MyListen<: DownloadListener{

    public func taskStart(task:DownloadTask):Unit{
    }

    public func connectTrialStart(task:DownloadTask,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
    }

    public func connectTrialEnd(task:DownloadTask,responseCode:Int64,responseHeaderFields:HashMap<String, ArrayList<String>>):Unit{
    }

    public func downloadFromBeginning(task:DownloadTask):Unit{
    }

    public func downloadFromBreakpoint(task:DownloadTask):Unit{
    }

    public func connectStart(task:DownloadTask,blockIndex:Int64,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
    }

    public func connectEnd(task:DownloadTask,blockIndex:Int64,responseCode:Int64,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
    }

    public func fetchStart(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit{
    }

    public func fetchProgress(task:DownloadTask,blockIndex:Int64,increaseBytes:Int64):Unit{
    }

    public func fetchEnd(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit{
    }

    public func taskEnd(task:DownloadTask,realCause:Option<Exception>):Unit{
        isComplete = true
    }
}

```

```cangjie

FILE   : maintest06.cj

[02-15 21:53:00] INFO - FILE   : maintest06.cj
[02-15 21:53:03] INFO - CMD    : ./main
[02-15 21:53:03] INFO - FILE   : maintest06.cj
[02-15 21:53:06] INFO - return : 0
[02-15 21:53:06] INFO -  >>=============================================<<
[02-15 21:53:06] INFO -
[02-15 21:53:06] INFO -
[02-15 21:53:06] INFO -
[02-15 21:53:06] INFO -   TestSuiteTask: Total: 1, PASS: 1, FAIL: 0

```

