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

    /* 获取下载时候的连接数
     *
     * 返回值Int64类型,获取下载连接数
     */
    public func getConnectionCount():Int64{

}
```

```cangjie
public class DownloadListener{

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


from okdownload import okdownload.*
from std import collection.*
from std import fs.*

main(){

    var url:String = "https://cdn.llscdn.com/yy/files/xs8qmxn8-lls-LLS-5.8-800-20171207-111607.apk"

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

     task.execute(MyListen())
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
    }
}

```

```cangjie

FILE   : maintest01.cj
[02-07 17:40:42] INFO - CMD    : ./main
[02-07 17:40:42] INFO - FILE   : maintest01.cj
[02-07 17:40:45] INFO - Stdout : 进来了
[02-07 17:40:45] INFO - Stdout : 下载成功
[02-07 17:40:45] INFO - return : 0

```

####  异步下载

```

// EXEC: cjc %import-path %L %l %f
// EXEC: ./main


from okdownload import okdownload.*
from std import collection.*
from std import fs.*

main(){

    var url:String = "https://cdn.llscdn.com/yy/files/xs8qmxn8-lls-LLS-5.8-800-20171207-111607.apk"

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
    }
}

```

```cangjie

FILE   : maintest06.cj
[02-07 17:42:16] INFO - CMD    : ./main
[02-07 17:42:16] INFO - FILE   : maintest06.cj
[02-07 17:42:19] INFO - Stdout : 进来了
[02-07 17:42:19] INFO - Stdout : 下载成功
[02-07 17:42:19] INFO - return : 0

```


















#### 1 需求场景分析

一个可靠、灵活、快速和强大的下载引擎

#### 2 三方库对外提供的特性

（1） 支持单线程多线程同步下载

#### 3 License分析

 Apache 2.0 license

|  Permissions   | Limitations  |
|  ----  | ----  |
| Commercial use | Liability |
| Modification  | Warranty |
| Distribution  |   |
| Private use   |   |

#### 4 依赖分析

依赖

仓颉版okhttp


#### 5 特性设计文档

##### 5.1 核心特性1

###### 5.1.1 特性介绍

    okdwonload多线程同步下载

###### 5.1.2 实现方案

    首先创建一个下载任务对象DownloadTask，然后对下载任务对象进行一层封装，封装成DownloadCall，然后在DownloadCall中进行下载前的校验，校验通过后，根据下载策略，通过判断下载的文件的
    大小，会分配一定数量的线程去分片下载这个任务，也就是说会对文件进行多片下载，前提是服务端支持和客户端的输出流支持seek.然后就是多个线程去分片下载对应的流数据和输出流分别从指定的seek点
    写入文件。下载的时候是通过okhttp去下载。

###### 5.1.3 接口设计


💡 DownloadTaskBuilder DownloadTask的任务构建对象

| 成员函数 | 入参 | 返回值 | 作用描述 |
| --- | --- |  --- | --- |
| init   | url:String,file:Directory | DownloadTaskBuilder | 用于构造DownloadTaskBuilder对象 |
| setFilename   | filename:String | DownloadTaskBuilder | 用于设置下载文件的名称 |
| setMinIntervalMillisCallbackProcess   | minIntervalMillisCallbackProcess:Int64 | DownloadTaskBuilder | 设置进度回调的时间间隔 |
| setReadBufferSize   | readBufferSize:Int64 | DownloadTaskBuilder | 设置读取缓存大小|
| setFlushBufferSize   |flushBufferSize:Int64 | DownloadTaskBuilder | 设置刷新缓冲大小 |
| build   | 无 | DownloadTask | 用于构造DownloadTask对象 |


💡 DownloadTask 任务对象类

| 成员函数 | 入参 | 返回值 | 作用描述 |
| --- | --- | --- | --- |
| execute   | listener:DownloadListener | Unit | 用于执行同步下载 |
| enqueue   | listener:DownloadListener | Unit | 用于执行异步下载 |
| enqueues   | tasks:Array<DownloadTask>，listener:DownloadListener | Unit | 用于执行异步下载多个任务 |
| getId   | 无 | Int64 | 获取任务的Id|
| getFilename   | 无 | Option<String> | 获取文件名 |
| getUrl   | 无 | String | 获取文件下载路径 |
| getUri   | 无 | URL | 获取下载下来的文件的父文件夹 |
| getProvidedPathFile   | 无 | File | 获取下载后的文件 |
| getReadBufferSize   | 无 | Int64 | 获取读取文件的缓存大小 |
| getFlushBufferSize   | 无 | Int64 | 获取刷新的缓冲大小 |
| getConnectionCount   | 无 | Int64 | 获取下载时候的连接数 |



💡 DownloadListener 下载任务回调接口类

| 成员函数 | 入参 | 返回值 | 作用描述 |
| --- | --- | --- | --- |
| taskStart   | task:DownloadTask | Unit | 任务刚开始的回调 |
| connectTrialStart   | task:DownloadTask,requestHeaderFields:HashMap<String, ArrayList<String>> | Unit | 任务开始尝试连接的回调|
| connectTrialEnd   | task:DownloadTask,responseCode:Int64,responseHeaderFields:HashMap<String, ArrayList<String>> | Unit | 任务结束尝试连接的回调 |
| downloadFromBeginning   | task:DownloadTask | Unit | 从开始下载的回调 |
| downloadFromBreakpoint   | task:DownloadTask | Unit | 从断点处下载的回调 |
| connectStart   | task:DownloadTask,blockIndex:Int64,requestHeaderFields:HashMap<String, ArrayList<String>> | Unit | 连接开始的回调 |
| connectEnd   | task:DownloadTask,blockIndex:Int64,responseCode:Int64,requestHeaderFields:HashMap<String, ArrayList<String>> | Unit | 连接结束的回调 |
| fetchStart   | task:DownloadTask,blockIndex:Int64,contentLength:Int64 | Unit | 开始获取进度的回调 |
| fetchProgress   | task:DownloadTask,blockIndex:Int64,increaseBytes:Int64 | Unit | 获取进度的回调 |
| fetchEnd   | task:DownloadTask,blockIndex:Int64,contentLength:Int64 | Unit | 获取进度结束的回调 |
| taskEnd   | task:DownloadTask,realCause:Option<Exception> | Unit | 任务结束的回调 |


###### 5.1.4 展示示例
```cangjie
okdwonload同步下载案例:

// EXEC: cjc %import-path %L %l %f
// EXEC: ./main


from okdownload import okdownload.*
from std import collection.*
from std import fs.*

main(){

    var url:String = "https://cdn.llscdn.com/yy/files/xs8qmxn8-lls-LLS-5.8-800-20171207-111607.apk"
    let lastIndex:Int64 = url.lastIndexOf(".").getOrThrow()
    var FileEnds = url.substring(lastIndex)
    //println("FileEnds="+FileEnds)

    let filenamePre:String = "single-test"
    let filename = filenamePre+FileEnds

    let parentFilePath:Path = Path("./fileDownLoad0")
    var parentFile:Option<Directory> = Option<Directory>.None

    if (!Directory.exists(parentFilePath)) {
        parentFile = Directory.create(parentFilePath, recursive: true)
    }else{
    }

    //let parentFile:File = File(parentFilePath,OpenOption.Create(true))
    let task:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
         .setFilename(filename)
         // the minimal interval millisecond for callback progress
         .setMinIntervalMillisCallbackProcess(30)
         .build()

     task.execute(MyListen())
     //task.enqueue(MyListen())
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
    }
}




```

#### 🚀 6 架构图

<img alt="" src="./assets/okdownloadclassrelation.png" style="display: inline-block;" width=60%/>
<img alt="" src="./assets/okdownloadclassshuoming.png" style="display: inline-block;" width=60%/>

