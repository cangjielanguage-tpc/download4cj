## okdownload 库

### 介绍
可靠、灵活、快速和强大的下载引擎。提供同步下载,异步下载 参考地址 https://github.com/lingochamp/okdownload.git

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
     * 参数 url - 要下载的文件的url
     * 参数 file - 把下载下来的文件放到哪个目录下
     */
    public init(url:String,file:Directory)

    /* 用于设置下载文件的名称
     *
     * 参数 filename - 设置给下载下来的文件的名字
     * 返回值 - 返回一个DownloadTaskBuilder
     * 注意：文件名优先用户自己设置的，如果用户没设置会去取请求返回的，如果都没有，就去截取url,截取失败随机生成
     */
    public func setFilename(filename:String):DownloadTaskBuilder

    /* 设置进度回调的时间间隔
     *
     * 参数 minIntervalMillisCallbackProcess - 下载的时候多少毫秒进行一次回调
     * 返回值 - 返回一个DownloadTaskBuilder
     */
    public func setMinIntervalMillisCallbackProcess(minIntervalMillisCallbackProcess:Int64):DownloadTaskBuilder

    /* 设置读取缓存大小
     *
     * 参数 readBufferSize - 下载的时候的读取缓冲的大小
     * 返回值 - 返回一个DownloadTaskBuilder
     */
    public func setReadBufferSize(readBufferSize:Int64):DownloadTaskBuilder

    /*
     * 设置刷新缓冲大小
     *
     * 参数 flushBufferSize - 刷缓冲的大小
     * 返回值 - 返回一个DownloadTaskBuilder
     */
    public func setFlushBufferSize(flushBufferSize:Int64):DownloadTaskBuilder

     /* 用于构造DownloadTask对象
     *
     * 返回值 - 返回一个DownloadTask
     */
    public func build():DownloadTask

```

class DownloadTask

```cangjie
    /* 用于执行同步下载
     *
     * 参数 listener - 下载的时候的监听类
     */
    public func execute(listener:DownloadListener)

    /*
     * 获取任务的Id
     * 返回值 - 返回任务的id
     */
    public func getId():Int64

    /* 获取文件名
     *
     * 返回值 - 返回文件的名字
     */
    public func getFilename():Option<String>

    /* 获取文件下载路径
     *
     * 返回值 - 返回文件的下载url路径
     */
    public func getUrl():String

    /* 获取下载下来的文件的父文件夹
     *
     * 返回值 - 返回文件的文件夹对应的URL
     */
    public func getUri():URL

    /* 获取下载后的文件
     *
     * 返回值 - 返回下载后的文件对象
     */
    public func getProvidedPathFile():File

    /* 获取读取文件的缓存大小
     *
     * 返回值 - 返回获取下载时候的读取缓冲大小
     */
    public func getReadBufferSize():Int64

    /* 获取刷新的缓冲大小
     *
     * 返回值 - 返回下载写入时候的冲刷缓冲大小
     */
    public func getFlushBufferSize():Int64

    /*获取回调时间间隔数
     *
     * 返回值 - 返回下载进度回调的时间间隔数，单位毫秒
     */
    public func getMinIntervalMillisCallbackProcess():Int64

    /* 获取下载时候的连接数
     *
     * 返回值 - 返回下载连接数
     */
    public func getConnectionCount():Int64

    /* 下载任务对象的toString方法
     *
     * 返回值 - 返回下载任务对象对应的String
     */
    public func toString():String

```
interface DownloadListener

```cangjie

/* 任务刚开始的回调
     *
     * 参数 task - 下载的任务对象
     */
    func taskStart(task:DownloadTask)

    /* 任务开始尝试连接的回调
     *
     * 参数 task - 下载的任务对象
     * 参数 requestHeaderFields - 请求的header
     */
    func connectTrialStart(task:DownloadTask,requestHeaderFields:HashMap<String, ArrayList<String>>)

    /* 任务结束尝试连接的回调
     *
     * 参数 task - 下载的任务对象
     * 参数 responseCode - 请求返回的响应码
     * 参数 responseHeaderFields - 响应的haeder
     */
    func connectTrialEnd(task:DownloadTask,responseCode:Int64,responseHeaderFields:HashMap<String, ArrayList<String>>)

    /* 从开始下载的回调
     *
     * 参数 task - 下载的任务对象
     */
    func downloadFromBeginning(task:DownloadTask)

    /* 从断点处下载的回调
     *
     * 参数 task - 下载的任务对象
     */
    func downloadFromBreakpoint(task:DownloadTask)

    /* 连接开始的回调
     *
     * 参数 task - 下载的任务对象
     * 参数 blockIndex - 对应的分块index
     * 参数 requestHeaderFields - 请求的请求头
     */
    func connectStart(task:DownloadTask,blockIndex:Int64,requestHeaderFields:HashMap<String, ArrayList<String>>)

    /* 连接结束的回调
     *
     * 参数 task - 下载的任务对象
     * 参数 blockIndex - 对应的分块index
     * 参数 responseCode - 请求返回的响应码
     * 参数 responseHeaderFields - 响应的haeder
     */
    func connectEnd(task:DownloadTask,blockIndex:Int64,responseCode:Int64,responseHeaderFields:HashMap<String, ArrayList<String>>)

    /* 开始获取进度的回调
     *
     * 参数 task - 下载的任务对象
     * 参数 blockIndex - 对应的分块index
     * 参数 contentLength - 下载的内容长度
     */
    func fetchStart(task:DownloadTask,blockIndex:Int64,contentLength:Int64)

    /* 获取进度的回调
     *
     * 参数 task - 下载的任务对象
     * 参数 blockIndex - 对应的分块index
     * 参数 increaseBytes - 下载增加的部分字节数
     */
    func fetchProgress(task:DownloadTask,blockIndex:Int64,increaseBytes:Int64)

    /* 获取进度结束的回调
     *
     * 参数 task - 下载的任务对象
     * 参数 blockIndex - 对应的分块index
     * 参数 contentLength - 下载的内容长度
     */
    func fetchEnd(task:DownloadTask,blockIndex:Int64,contentLength:Int64)

    /* 任务结束的回调
     *
     * 参数 task - 下载的任务对象
     * 参数 realCause - 造成异常结束的原因
     */
    func taskEnd(task:DownloadTask,realCause:Option<Exception>)

```


##### 1.1.1.1 示例

```cangjie

from okdownload import okdownload.*
from std import collection.*
from std import fs.*

var isComplete = false

main(){
    var url:String = "http://imgsrc.baidu.com/forum/w%3D580/sign=eed1753686d6277fe9123230183a1f63/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"
    let lastIndex:Int64 = url.lastIndexOf(".").getOrThrow()
    var FileEnds = url.substring(lastIndex)
    let filenamePre:String = "single-test"
    let filename = filenamePre+FileEnds
    let parentFilePath:Path = Path("./fileDownLoad")
    var parentFile:Option<Directory> = Option<Directory>.None
    if (!Directory.exists(parentFilePath)) {
        parentFile = Directory.create(parentFilePath, recursive: true)
    }
    let task:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
        .setFilename(filename)
        .setMinIntervalMillisCallbackProcess(30)
        .setReadBufferSize(4096)
        .setFlushBufferSize(16384)
        .build()
    task.execute(MyListen())
    if(isComplete){
        println(isComplete)
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

true

```


#### 1.2 任务异步的下载和异步下载多个文件
可以异步下载单个文件或多个文件

##### 1.2.1 主要接口

class DownloadTaskBuilder

```cangjie
    /* 用于构造DownloadTaskBuilder对象
     *
     * 参数 url - 要下载的文件的url
     * 参数 file - 把下载下来的文件放到哪个目录下
     */
    public init(url:String,file:Directory){

    /* 设置进度回调的时间间隔
     *
     * 参数 minIntervalMillisCallbackProcess - 下载的时候多少毫秒进行一次回调
     * 返回值 - 返回一个DownloadTaskBuilder
     */
    public func setMinIntervalMillisCallbackProcess(minIntervalMillisCallbackProcess:Int64):DownloadTaskBuilder{

    /* 用于设置下载文件的名称
     *
     * 参数 filename - 设置给下载下来的文件的名字
     * 返回值 - 返回一个DownloadTaskBuilder
     * 注意：文件名优先用户自己设置的，如果用户没设置会去取请求返回的，如果都没有，就去截取url,截取失败随机生成
     */
    public func setFilename(filename:String):DownloadTaskBuilder{

     /* 用于构造DownloadTask对象
     *
     * 返回值 - 返回一个DownloadTask
     */
    public func build():DownloadTask{

```

class DownloadTask

```cangjie

     /* 用于执行异步下载
     *
     * 参数 listener - 下载的时候的监听类
     */
    public func enqueue(listener:DownloadListener){

    /* 用于执行异步下载多个任务
     *
     * 参数 tasks - 要下载的任务的数组
     * 参数 listener - 下载的时候的监听类
     */
    public static func enqueues(tasks:Array<DownloadTask>,listener:DownloadListener){

```

##### 1.2.1.1 示例

```cangjie

from okdownload import okdownload.*
from std import collection.*
from std import fs.*

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
    }
    let task:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
         .setFilename(filename)
         .setMinIntervalMillisCallbackProcess(30)
         .build()
     task.enqueue(MyListen())
     sleep(1000*1000*1000*3)
     if(isComplete){
        println(isComplete)
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

true

```


##### 1.2.1.2 示例

```cangjie

from okdownload import okdownload.*
from std import collection.*
from std import fs.*

var i = 0

main(){
    var url:String = "http://imgsrc.baidu.com/forum/w%3D580/sign=eed1753686d6277fe9123230183a1f63/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"
    let parentFilePath:Path = Path("./fileDownLoad0")
    var parentFile:Option<Directory> = Option<Directory>.None
    if (!Directory.exists(parentFilePath)) {
        parentFile = Directory.create(parentFilePath, recursive: true)
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
        println(i)
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

5

```

## 其他接口

### 介绍

    这些接口在内部流程中使用, 无需调用者操作, 也有可能随迭代修改其实现，请按需谨慎使用。

### 主要接口

#### RetryInterceptor

```cangjie
/*
 * 重试拦截器
 */
public class RetryInterceptor <: InterceptorConnect & InterceptorFetch{
    /*
     * 重试拦截器
     * 参数 chain - 下载的块对象
     * 返回值 - 返回网络请求的连接对象
     */
    public func interceptConnect(chain:DownloadChain):Option<DownloadConnectionConnected>
    /*
     * 触发获取下载文件数据
     * 参数 chain - 下载的块对象
     * 返回值 - 返回最后下载完成后文件的长度
     */
    public func interceptFetch(chain:DownloadChain):Int64
}
```

#### BreakpointInterceptor

```cangjie
/*
 * 每一个块Block下载时候的断点拦截器
 */
public class BreakpointInterceptor <: InterceptorConnect & InterceptorFetch
    /*
     * 拦截器执行的时候对断点信息的检查
     * 参数 chain - 下载的块对象
     * 返回值 - 返回网络请求的连接对象
     */
    public func interceptConnect(chain:DownloadChain):Option<DownloadConnectionConnected>
    /*
     * 循环下载文件的方法
     * 参数 chain - 下载的块对象
     * 返回值 - 返回最后下载完成后文件的长度
     */
    public func interceptFetch(chain:DownloadChain):Int64
}
```

#### HeaderInterceptor

```cangjie
/*
 * 每一个块Block下载时候的请求头拦截器
 */
public class HeaderInterceptor <: InterceptorConnect{
    /*
     * 拦截器执行的时候对请求头的处理
     * 参数 chain - 下载的块对象
     * 返回值 - 返回网络请求的连接对象
     */
    public func interceptConnect(chain:DownloadChain):Option<DownloadConnectionConnected>
}
```

#### CallServerInterceptor

```cangjie
/*
 * 每一个块Block的执行请求拦截器
 */
public class CallServerInterceptor <: InterceptorConnect{
    /*
     * 执行网络请求处理
     * 参数 chain - 下载的块对象
     * 返回值 - 返回网络请求的连接对象
     */
    public func interceptConnect(chain:DownloadChain):Option<DownloadConnectionConnected>
}
```

#### FetchDataInterceptor

```cangjie
/*
 * 请求网络获取文件数据的方法
 */
public class FetchDataInterceptor <: InterceptorFetch {
    /*
     * 执行网络请求处理
     * 参数 chain - 下载的块对象
     * 返回值 - 返回每一次read获取到的字节数
     */
    public func interceptFetch(chain:DownloadChain):Int64
}
```

#### DownloadUriOutputStream

```cangjie
/*
 * 下载文件时候的OutputStream管理类
 */
public class DownloadUriOutputStream <: DownloadOutputStream{
    /*
     * 写文件的方法
     * 参数 b - 要写的文件内容
     * 参数 off - 从哪里写起
     * 参数 len - 写多少长度
     */
    public func write(b:Array<UInt8>,off:Int64,len:Int64)
    /*
     * 关闭流的方法
     */
    public func close():Unit
    /*
     * 刷新流的方法
     */
    public func flushAndSync():Unit
    /*
     * 让文件指定某个位置开始写
     * 参数 offset - 指定开始写的位置
     */
    public func seek(offset:Int64):Unit
    /*
     * 指定文件长度
     * 参数 newLength - 文件长度
     */
    public func setLength(newLength:Int64):Unit
}
```

#### DownloadUriOutputStreamFactory

```cangjie
/*
 * 创建DownloadUriOutputStream类的工厂类
 */
public class FetchDataInterceptor <: InterceptorFetch {
    /*
     * 创建DownloadUriOutputStream对象
     * 参数 file - 对于的要写的文件
     * 参数 flushBufferSize - 输出流的flushBufferSize
     * 返回值 - 返回一个DownloadOutputStream
     */
    public func create(file:File,flushBufferSize:Int64):DownloadOutputStream
    /*
     * 创建DownloadUriOutputStream对象
     * 参数 url - 对于的要写的文件的URL
     * 参数 flushBufferSize - 输出流的flushBufferSize
     * 返回值 - 返回一个DownloadOutputStream
     */
    public func create(url:URL,flushBufferSize:Int64):DownloadOutputStream
    /*
     * 是否支持seek
     * 返回值 - true支持seek false不支持seek
     */
    public func supportSeek():Bool
}

```

#### DownloadOkHttp3Connection

```cangjie
/*
 * okhttp的连接核心类
 */
public class DownloadOkHttp3Connection <: DownloadConnection & DownloadConnectionConnected{
    /*
     * 添加请求头
     * 参数 name - 请求头的key
     * 参数 value - 请求头的value
     */
    public func addHeader(name:String,value:String):Unit
    /*
     * 执行okhttp请求
     * 返回值 - 返回okhttp请求的连接对象
     */
    public func execute():DownloadConnectionConnected
    /*
     * 释放okhttp请求的资源
     */
    public func release():Unit
    /*
     * 获取所有请求头
     * 返回值 - 返回请求头的key value对
     */
    public func getRequestProperties():HashMap<String, ArrayList<String>>
    /*
     * 根据单个key获取所对应的请求头
     * 参数 key - 请求头的key
     * 返回值 - 返回对应请求头的value
     */
    public func getRequestProperty(key:String):String
    /*
     * 获取响应码
     * 返回值 - 返回请求的响应码
     */
    public func getResponseCode():Int64
    /*
     * 获取请求的流
     * 返回值 - 返回okhttp请求的读取流
     */
    public func getInputStream():Source
    /*
     * 设置请求方式
     * 参数 method - 请求的方式
     * 返回值 - true支持成功 false表示失败
     */
    public func setRequestMethod(method:String):Bool
    /*
     * 获取响应头
     * 返回值 - 返回响应头的key value对
     */
    public func getResponseHeaderFields():Option<HashMap<String,ArrayList<String>>>
    /*
     * 根据响应头的key获取响应头的value
     * 参数 name - 响应头的key
     * 返回值 - 返回对应的响应头的value
     */
    public func getResponseHeaderField(name:String):Option<String>
    /*
     * 获取重定向地址
     * 返回值 - 返回重定向的地址
     */
    public func getRedirectLocation():Option<String>
}

```

#### DownloadOkHttp3ConnectionFactory

```cangjie
/*
 * okhttp连接的工厂类
 */
public class DownloadOkHttp3ConnectionFactory <: DownloadConnectionFactory{
    /*
     * 根据url获取okhttp的连接对象
     * 参数 url - 下载的url路径
     * 返回值 - 返回okhttp的连接对象
     */
    public func create(url:String):DownloadConnection
}
```

#### DownloadCall

```cangjie
/*
 * 下载的请求类
 */
public class DownloadCall <: Equatable<DownloadCall>{
    /*
     * 判断两个连接请求是否一样
     * 参数 anothor - 另一个连接请求
     * 返回值 - true为一样 false不一样
     */
    public operator func ==(anothor: DownloadCall): Bool
    /*
     * 判断两个连接请求是否不一样
     * 参数 anothor - 另一个连接请求
     * 返回值 - true不一样 false一样
     */
    public operator func !=(anothor: DownloadCall): Bool
}
```

#### FileNameHolder

```cangjie
/*
 * 文件名持有类
 */
public class FileNameHolder <: Hashable & Equatable<FileNameHolder> {
    /*
     * 判断两个持有类的文件名是否一样
     * 参数 holder - 另一个文件名持有类对象
     * 返回值 - true为一样 false不一样
     */
    public operator func ==(holder: FileNameHolder): Bool
    /*
     * 判断两个持有类的文件名是否不一样
     * 参数 holder - 另一个文件名持有类对象
     * 返回值 - true不一样 false一样
     */
    public operator func !=(holder: FileNameHolder): Bool
    /*
     * 文件名持有类对象的hashCode
     * 返回值 - 返回文件名持有类对象的hashCode值
     */
    public func hashCode(): Int64
}
```

#### DownloadTask

```cangjie
/*
 * 下载任务类
 */
public class DownloadTask <: IdentifiedTask & Hashable & Equatable<DownloadTask>{
    /*
     * 获取下载任务对象对于的hashCode值
     * 返回值 - 返回下载任务对象对应的hashCode值
     */
    public func hashCode(): Int64
    /*
     * 判断两个下载任务对象是否一样
     * 参数 anothor - 另一个下载任务对象
     * 返回值 - true一样 false不一样
     */
    public operator func ==(anothor: DownloadTask): Bool
    /*
     * 判断两个下载任务对象是否不一样
     * 参数 anothor - 另一个下载任务对象
     * 返回值 - true不一样 false一样
     */
    public operator func !=(anothor: DownloadTask): Bool
    /*
     * 根据taskid模仿一个task
     * 参数 id - 下载任务的id
     * 返回值 - 返回模仿的下载任务task
     */
    public func mock(id:Int64):MockTaskForCompare
}
```

#### DefaultTransmitListener

```cangjie
/*
 * 内部默认监听类
 */
public class DefaultTransmitListener <: DownloadListener {
    /*
     * 任务刚开始的回调
     * 参数 task - 下载的任务对象
     */
    func taskStart(task:DownloadTask)

    /*
     * 任务开始尝试连接的回调
     * 参数 task - 下载的任务对象
     * 参数 requestHeaderFields - 请求的header
     */
    func connectTrialStart(task:DownloadTask,requestHeaderFields:HashMap<String, ArrayList<String>>)

    /*
     * 任务结束尝试连接的回调
     * 参数 task - 下载的任务对象
     * 参数 responseCode - 请求返回的响应码
     * 参数 responseHeaderFields - 响应的haeder
     */
    func connectTrialEnd(task:DownloadTask,responseCode:Int64,responseHeaderFields:HashMap<String, ArrayList<String>>)

    /*
     * 从开始下载的回调
     * 参数 task - 下载的任务对象
     */
    func downloadFromBeginning(task:DownloadTask)

    /*
     * 从断点处下载的回调
     * 参数 task - 下载的任务对象
     */
    func downloadFromBreakpoint(task:DownloadTask)

    /*
     * 连接开始的回调
     * 参数 task - 下载的任务对象
     * 参数 blockIndex - 对应的分块index
     * 参数 requestHeaderFields - 请求的请求头
     */
    func connectStart(task:DownloadTask,blockIndex:Int64,requestHeaderFields:HashMap<String, ArrayList<String>>)

    /*
     * 连接结束的回调
     * 参数 task - 下载的任务对象
     * 参数 blockIndex - 对应的分块index
     * 参数 responseCode - 请求返回的响应码
     * 参数 responseHeaderFields - 响应的haeder
     */
    func connectEnd(task:DownloadTask,blockIndex:Int64,responseCode:Int64,responseHeaderFields:HashMap<String, ArrayList<String>>)

    /*
     * 开始获取进度的回调
     * 参数 task - 下载的任务对象
     * 参数 blockIndex - 对应的分块index
     * 参数 contentLength - 下载的内容长度
     */
    func fetchStart(task:DownloadTask,blockIndex:Int64,contentLength:Int64)

    /*
     * 获取进度的回调
     * 参数 task - 下载的任务对象
     * 参数 blockIndex - 对应的分块index
     * 参数 increaseBytes - 下载增加的部分字节数
     */
    func fetchProgress(task:DownloadTask,blockIndex:Int64,increaseBytes:Int64)

    /*
     * 获取进度结束的回调
     * 参数 task - 下载的任务对象
     * 参数 blockIndex - 对应的分块index
     * 参数 contentLength - 下载的内容长度
     */
    func fetchEnd(task:DownloadTask,blockIndex:Int64,contentLength:Int64)

    /*
     * 任务结束的回调
     * 参数 task - 下载的任务对象
     * 参数 realCause - 造成异常结束的原因
     */
    func taskEnd(task:DownloadTask,realCause:Option<Exception>)
}
```

#### BreakpointStoreOnCache

```cangjie
/*
 * 断点存储缓存类
 */
public class BreakpointStoreOnCache <: DownloadStore{
    /*
     * 获取对应id的断点对象
     * 参数 id - 断点对象的id
     * 返回值 - 返回断点信息对象
     */
    public func get(id:Int64):Option<BreakpointInfo>
    /*
     * 创建或者插入断点
     * 参数 task - 任务类对象
     * 返回值 - 返回断点信息对象
     */
    public func createAndInsert(task:DownloadTask):BreakpointInfo
    /*
     * 断点任务开始时候的方法
     * 参数 id - 断点的id
     */
    public func onTaskStart(id:Int64):Unit
     /*
     * 断点信息同步文件
     * 参数 info - 断点信息
     * 参数 blockIndex - 下载块的索引
     * 参数 increaseLength - 增加的文件长度
     */
    public func onSyncToFilesystemSuccess(info:BreakpointInfo,blockIndex:Int64,increaseLength:Int64):Unit
    /*
     * 替换断点信息
     * 参数 breakpointInfo - 要替换的断点对象
     * 返回值 - true替换成功 false替换失败
     */
    public func update(breakpointInfo:BreakpointInfo):Bool
    /*
     * 断点任务结束后的方法
     * 参数 id - 断点id
     * 参数 cause - 结束类型
     * 参数 exception - 异常原因
     */
    public func onTaskEnd(id:Int64,cause:EndCause,exception:Option<Exception>):Unit
     /*
     * 任务结束后的id获取断点信息
     * 参数 id - 断点的id
     * 返回值 - 返回的断点对象
     */
    public func getAfterCompleted(id:Int64):Option<BreakpointInfo>
    /*
     * 标记脏文件
     * 参数 id - 断点信息的id
     * 返回值 - true脏文件 false不是脏文件
     */
    public func markFileDirty(id:Int64):Bool
    /*
     * 根据id清除标记的脏文件
     * 参数 id - 断点信息的id
     * 返回值 - true移除成功 false移除失败
     */
    public func markFileClear(id:Int64):Bool
     /*
     * 根据id删除断点信息
     * 参数 id - 断点信息的id
     */
    public func remove(id:Int64):Unit
    /*
     * 找到对于下载任务的断点信息id
     * 参数 task - 下载任务
     * 返回值 - 返回断点信息的id
     */
    public func findOrCreateId(task:DownloadTask):Int64
    /*
     * 找到文件名字一样任务的断点信息
     * 参数 task - 下载任务
     * 参数 ignored - 对比的断点信息
     * 返回值 - 返回找到的断点信息
     */
    public func findAnotherInfoFromCompare(task:DownloadTask,ignored:BreakpointInfo):Option<BreakpointInfo>
    /*
     * 是否只支持内存缓存
     * 返回值 - true只支持内存缓存 false不是
     */
    public func isOnlyMemoryCache():Bool
}
```




