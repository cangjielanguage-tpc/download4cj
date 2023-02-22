## okdownload 库

### 介绍
可靠、灵活、快速和强大的下载引擎。0.0.1版本提供同步下载  0.0.2提供异步下载 参考地址 https://github.com/lingochamp/okdownload.git

### 1 提供文件的同步下载和异步下载的功能

前置条件：NA
场景：
   在网络上需要下载文件到本地硬盘时候，可以采取同步线程下载的方式。
   在网络上需要下载文件到本地硬盘时候，可以采取异步线程下载的方式。
   在网络上需要下载文件到本地硬盘时候，可以采取异步线程下载多个文件的方式。
约束：
性能： 支持版本几何性能持平
可靠性： NA

#### 1.1 任务的同步下载（开发时候包含设置下载策略组件）
可以同步将url对应的文件路径下载到指定目录

##### 1.1.1 主要接口

class DownloadTaskBuilder

```cangjie
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

    /*
     * 设置刷新缓冲大小
     * 参数 Int64类型 刷缓冲的大小
     * 返回值 DownloadTaskBuilder类型 构建DownloadTask的构建类
     */
    public func setFlushBufferSize(flushBufferSize:Int64):DownloadTaskBuilder

     /* 用于构造DownloadTask对象
     *
     * 返回值 DownloadTask类型 构建的DownloadTask对象
     */
    public func build():DownloadTask{

```

class DownloadTask

```cangjie
    /* 用于执行同步下载
     *
     * 参数 DownloadListener类型 下载的时候的监听类
     */
    public func execute(listener:DownloadListener){

    /*
     * 获取任务的Id
     * 返回值 Int64类型 任务的id
     */
    public func getId():Int64

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

```
interface DownloadListener

```cangjie

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

```


##### 1.1.1.1 示例

```cangjie

// EXEC: cjc %import-path %L %l %f
// EXEC: ./main


from okdownload import okdownload.*
from std import collection.*
from std import fs.*


//目的 主要为了验证循环同步下载

var isComplete = false

main(){


        var url:String = "https://www.voidtools.com/Everything-1.4.1.1017.x64-Setup.exe"
        let lastIndex:Int64 = url.lastIndexOf(".").getOrThrow()
        var FileEnds = url.substring(lastIndex)

        let filenamePre:String = "single-test"
        let filename = filenamePre+FileEnds

        let parentFilePath:Path = Path("./fileDownLoad")
        var parentFile:Option<Directory> = Option<Directory>.None

        if (!Directory.exists(parentFilePath)) {
            parentFile = Directory.create(parentFilePath, recursive: true)
        }else{
        }

        let task:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
            .setFilename(filename)
            .setMinIntervalMillisCallbackProcess(30)
            .setReadBufferSize(4096)
            .setFlushBufferSize(16384)
            .build()

        task.execute(MyListen())

        println("taskId="+task.getId().toString())
        println("fileName="+task.getFilename().getOrThrow())
        println("url="+task.getUrl())
        println("uri="+task.getUri().toString())
        println("ProvidedPathFile="+task.getProvidedPathFile().getOrThrow().info.path.toString())
        println("ReadBufferSize="+task.getReadBufferSize().toString())
        println("FlushBufferSize="+task.getFlushBufferSize().toString())
        println("MinIntervalMillisCallbackProcess="+task.getMinIntervalMillisCallbackProcess().toString())
        println("ConnectionCount="+task.getConnectionCount().toString())

        if(isComplete){
          return 0
        }else{
          return 1
        }

}

public class MyListen<: DownloadListener{
    public func taskStart(task:DownloadTask):Unit{
        println("==================taskStart=======================")
        println("task.getId="+task.getId().toString())
    }
    public func connectTrialStart(task:DownloadTask,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
         println("==================connectTrialStart=======================")
         println("requestHeaderFields="+requestHeaderFields.toString())
         println("task.getId="+task.getId().toString())
    }

    public func connectTrialEnd(task:DownloadTask,responseCode:Int64,responseHeaderFields:HashMap<String, ArrayList<String>>):Unit{
         println("===============connectTrialEnd===================")
         println("responseCode="+responseCode.toString())
         println("responseHeaderFields="+responseHeaderFields.toString())
         println("task.getId="+task.getId().toString())
    }

    public func downloadFromBeginning(task:DownloadTask):Unit{
         println("===============downloadFromBeginning===================")
         println("task.getId="+task.getId().toString())
    }

    public func downloadFromBreakpoint(task:DownloadTask):Unit{
         println("===============downloadFromBreakpoint===================")
         println("task.getId="+task.getId().toString())

    }

    public func connectStart(task:DownloadTask,blockIndex:Int64,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
         println("===============connectStart===================")
         println("blockIndex="+blockIndex.toString())
         println("requestHeaderFields="+requestHeaderFields.toString())
         println("task.getId="+task.getId().toString())
    }

    public func connectEnd(task:DownloadTask,blockIndex:Int64,responseCode:Int64,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
         println("===============connectEnd===================")
         println("blockIndex="+blockIndex.toString())
         println("responseCode="+responseCode.toString())
         println("requestHeaderFields="+requestHeaderFields.toString())
         println("task.getId="+task.getId().toString())
    }

    public func fetchStart(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit{
         println("===============fetchStart===================")
         println("blockIndex="+blockIndex.toString())
         println("contentLength="+contentLength.toString())
         println("task.getId="+task.getId().toString())
    }

    public func fetchProgress(task:DownloadTask,blockIndex:Int64,increaseBytes:Int64):Unit{
     //     println("===============fetchProgress===================")
     //     println("blockIndex="+blockIndex.toString())
     //     println("increaseBytes="+increaseBytes.toString())
     //     println("task.getId="+task.getId().toString())
    }

    public func fetchEnd(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit{
         println("===============fetchEnd===================")
         println("blockIndex="+blockIndex.toString())
         println("contentLength="+contentLength.toString())
         println("task.getId="+task.getId().toString())
    }

    public func taskEnd(task:DownloadTask,realCause:Option<Exception>):Unit{
         println("===============taskEnd===================")
         println("task.getId="+task.getId().toString())
         isComplete = true
    }
}


```

执行结果如下：

```shell

[02-17 11:17:49] INFO - Stdout : ==================taskStart=======================
[02-17 11:17:49] INFO - Stdout : task.getId=1
[02-17 11:17:49] INFO - Stdout : ==================connectTrialStart=======================
[02-17 11:17:49] INFO - Stdout : requestHeaderFields=[(Range, [bytes=0-0])]
[02-17 11:17:49] INFO - Stdout : task.getId=1
[02-17 11:17:49] INFO - Stdout : ===============connectTrialEnd===================
[02-17 11:17:49] INFO - Stdout : responseCode=206
[02-17 11:17:49] INFO - Stdout : responseHeaderFields=[(Connection, [Keep-Alive]), (Keep-Alive, [timeout=5, max=100]), (Content-Type, [application/x-msdownload]), (Last-Modified, [Fri, 20 May 2022 01:43:18 GMT]), (Content-Range, [bytes 0-0/1862488]), (Content-Length, [1]), (Date, [Fri, 17 Feb 2023 03:17:47 GMT]), (Server, [LiteSpeed]), (Alt-Svc, [h3=":443"; ma=2592000, h3-29=":443"; ma=2592000, h3-Q050=":443"; ma=2592000, h3-Q046=":443"; ma=2592000, h3-Q043=":443"; ma=2592000, quic=":443"; ma=2592000; v="43,46"])]
[02-17 11:17:49] INFO - Stdout : task.getId=1
[02-17 11:17:49] INFO - Stdout : ===============downloadFromBeginning===================
[02-17 11:17:49] INFO - Stdout : task.getId=1
[02-17 11:17:49] INFO - Stdout : ===============connectStart===================
[02-17 11:17:49] INFO - Stdout : blockIndex=0
[02-17 11:17:49] INFO - Stdout : requestHeaderFields=[(User-Agent, [OkDownload/1.0.7]), (Range, [bytes=0-931243])]
[02-17 11:17:49] INFO - Stdout : task.getId=1
[02-17 11:17:49] INFO - Stdout : ===============connectStart===================
[02-17 11:17:49] INFO - Stdout : blockIndex=1
[02-17 11:17:49] INFO - Stdout : requestHeaderFields=[(User-Agent, [OkDownload/1.0.7]), (Range, [bytes=931244-1862487])]
[02-17 11:17:49] INFO - Stdout : task.getId=1
[02-17 11:17:49] INFO - Stdout : ===============connectEnd===================
[02-17 11:17:49] INFO - Stdout : blockIndex=0
[02-17 11:17:49] INFO - Stdout : responseCode=206
[02-17 11:17:49] INFO - Stdout : requestHeaderFields=[(Connection, [Keep-Alive]), (Keep-Alive, [timeout=5, max=100]), (Content-Type, [application/x-msdownload]), (Last-Modified, [Fri, 20 May 2022 01:43:18 GMT]), (Content-Range, [bytes 0-931243/1862488]), (Content-Length, [931244]), (Date, [Fri, 17 Feb 2023 03:17:47 GMT]), (Server, [LiteSpeed])]
[02-17 11:17:49] INFO - Stdout : task.getId=1
[02-17 11:17:49] INFO - Stdout : ===============fetchStart===================
[02-17 11:17:49] INFO - Stdout : blockIndex=0
[02-17 11:17:49] INFO - Stdout : contentLength=931244
[02-17 11:17:49] INFO - Stdout : task.getId=1
[02-17 11:17:49] INFO - Stdout : ===============connectEnd===================
[02-17 11:17:49] INFO - Stdout : blockIndex=1
[02-17 11:17:49] INFO - Stdout : responseCode=206
[02-17 11:17:49] INFO - Stdout : requestHeaderFields=[(Connection, [Keep-Alive]), (Keep-Alive, [timeout=5, max=100]), (Content-Type, [application/x-msdownload]), (Last-Modified, [Fri, 20 May 2022 01:43:18 GMT]), (Content-Range, [bytes 931244-1862487/1862488]), (Content-Length, [931244]), (Date, [Fri, 17 Feb 2023 03:17:48 GMT]), (Server, [LiteSpeed]), (Alt-Svc, [h3=":443"; ma=2592000, h3-29=":443"; ma=2592000, h3-Q050=":443"; ma=2592000, h3-Q046=":443"; ma=2592000, h3-Q043=":443"; ma=2592000, quic=":443"; ma=2592000; v="43,46"])]
[02-17 11:17:49] INFO - Stdout : task.getId=1
[02-17 11:17:49] INFO - Stdout : ===============fetchStart===================
[02-17 11:17:49] INFO - Stdout : blockIndex=1
[02-17 11:17:49] INFO - Stdout : contentLength=931244
[02-17 11:17:49] INFO - Stdout : task.getId=1
[02-17 11:17:49] INFO - Stdout : ===============fetchEnd===================
[02-17 11:17:49] INFO - Stdout : blockIndex=0
[02-17 11:17:49] INFO - Stdout : contentLength=931244
[02-17 11:17:49] INFO - Stdout : task.getId=1
[02-17 11:17:49] INFO - Stdout : ===============fetchEnd===================
[02-17 11:17:49] INFO - Stdout : blockIndex=1
[02-17 11:17:49] INFO - Stdout : contentLength=931244
[02-17 11:17:49] INFO - Stdout : task.getId=1
[02-17 11:17:49] INFO - Stdout : ===============taskEnd===================
[02-17 11:17:49] INFO - Stdout : task.getId=1



[02-17 11:17:49] INFO - Stdout : taskId=1
[02-17 11:17:49] INFO - Stdout : fileName=single-test.exe
[02-17 11:17:49] INFO - Stdout : url=https://www.voidtools.com/Everything-1.4.1.1017.x64-Setup.exe
[02-17 11:17:49] INFO - Stdout : uri=/home/hhs/ok-download/ci_test/test_temp/run/maintest15_cj_1676603863_843329/./fileDownLoad
[02-17 11:17:49] INFO - Stdout : ProvidedPathFile=/home/hhs/ok-download/ci_test/test_temp/run/maintest15_cj_1676603863_843329/./fileDownLoad/single-test.exe
[02-17 11:17:49] INFO - Stdout : ReadBufferSize=4096
[02-17 11:17:49] INFO - Stdout : FlushBufferSize=16384
[02-17 11:17:49] INFO - Stdout : MinIntervalMillisCallbackProcess=30
[02-17 11:17:49] INFO - Stdout : ConnectionCount=2
[02-17 11:17:49] INFO - return : 0


```


#### 1.2 任务异步的下载和异步下载多个文件
可以异步下载单个文件或多个文件

##### 1.2.1 主要接口

class DownloadTaskBuilder

```cangjie
    /* 用于构造DownloadTaskBuilder对象
     *
     * 参数 String类型 要下载的文件的url
     * 参数 Directory类型 把下载下来的文件放到哪个目录下
     */
    public init(url:String,file:Directory){

    /* 设置进度回调的时间间隔
     *
     * 参数 Int64类型 下载的时候多少毫秒进行一次回调
     * 返回值 DownloadTaskBuilder类型 构建DownloadTask的构建类
     */
    public func setMinIntervalMillisCallbackProcess(minIntervalMillisCallbackProcess:Int64):DownloadTaskBuilder{

    /* 用于设置下载文件的名称
     *
     * 参数 String类型 设置给下载下来的文件的名字
     * 返回值 DownloadTaskBuilder类型 构建DownloadTask的构建类
     */
    public func setFilename(filename:String):DownloadTaskBuilder{

     /* 用于构造DownloadTask对象
     *
     * 返回值 DownloadTask类型 构建的DownloadTask对象
     */
    public func build():DownloadTask{

```

class DownloadTask

```cangjie

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

```

##### 1.2.1.1 示例

```cangjie

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

执行结果如下：

```shell
[02-15 22:20:48] INFO - FILE   : maintest06.cj
[02-15 22:20:51] INFO - CMD    : ./main
[02-15 22:20:51] INFO - FILE   : maintest06.cj
[02-15 22:20:54] INFO - return : 0
[02-15 22:20:54] INFO -  >>=============================================<<
[02-15 22:20:54] INFO -
[02-15 22:20:54] INFO -
[02-15 22:20:54] INFO -
[02-15 22:20:54] INFO -   TestSuiteTask: Total: 1, PASS: 1, FAIL: 0

```


##### 1.2.1.2 示例

```cangjie

// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from okdownload import okdownload.*
from std import collection.*
from std import fs.*

var i = 0

//目的 主要为了验证异步下载多个相同的

main(){

    var url:String = "http://imgsrc.baidu.com/forum/w%3D580/sign=eed1753686d6277fe9123230183a1f63/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"


    let parentFilePath:Path = Path("./fileDownLoad0")
    var parentFile:Option<Directory> = Option<Directory>.None

    if (!Directory.exists(parentFilePath)) {
        parentFile = Directory.create(parentFilePath, recursive: true)
    }else{
    }

    var filename0 = "0.jpg"
    var filename1 = "1.jpg"
    var filename2 = "2.jpg"
    var filename3 = "3.jpg"
    var filename4 = "4.jpg"


    let task:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
        .setFilename(filename0)
         .setMinIntervalMillisCallbackProcess(30)
         .build()

    let task1:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
        .setFilename(filename1)
         .setMinIntervalMillisCallbackProcess(30)
         .build()

     let task2:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
        .setFilename(filename2)
         .setMinIntervalMillisCallbackProcess(30)
         .build()

    let task3:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
        .setFilename(filename3)
         .setMinIntervalMillisCallbackProcess(30)
         .build()

    let task4:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
        .setFilename(filename4)
        .setMinIntervalMillisCallbackProcess(30)
        .build()

    let tasklists:ArrayList<DownloadTask> = ArrayList<DownloadTask>()
    tasklists.append(task)
    tasklists.append(task1)
    tasklists.append(task2)
    tasklists.append(task3)
    tasklists.append(task4)
    let tasks:Array<DownloadTask> = Array<DownloadTask>(tasklists)


     DownloadTask.enqueues(tasks,MyListen())
     sleep(1000*1000*1000*8)
     if(i == tasklists.size){
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
        i++
    }
}
```

执行结果如下：

```shell

[02-15 22:24:27] INFO - FILE   : maintest05.cj
[02-15 22:24:31] INFO - CMD    : ./main
[02-15 22:24:31] INFO - FILE   : maintest05.cj
[02-15 22:24:39] INFO - return : 0
[02-15 22:24:39] INFO -  >>=============================================<<
[02-15 22:24:39] INFO -
[02-15 22:24:39] INFO -
[02-15 22:24:39] INFO -
[02-15 22:24:39] INFO -   TestSuiteTask: Total: 1, PASS: 1, FAIL: 0


```

