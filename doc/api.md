###  okdownload接口说明

主要是核心类和成员函数说明

#### class DownloadTaskBuilder


```
/*
 * 用于构造DownloadTaskBuilder对象
 * 参数 String类型 要下载的文件的url
 * 参数 Directory类型 把下载下来的文件放到哪个目录下
 */
public init(url:String,file:Directory)

```


```
/*
 * 用于设置下载文件的名称
 * 参数 String类型 设置给下载下来的文件的名字
 * 返回值 DownloadTaskBuilder类型 构建DownloadTask的构建类
 */
public func setFilename(filename:String):DownloadTaskBuilder

```


```
/*
 * 设置进度回调的时间间隔
 * 参数 Int64类型 下载的时候多少毫秒进行一次回调
 * 返回值 DownloadTaskBuilder类型 构建DownloadTask的构建类
 */
public func setMinIntervalMillisCallbackProcess(minIntervalMillisCallbackProcess:Int64):DownloadTaskBuilder

```


```
/*
 * 设置读取缓存大小
 * 参数 Int64类型 下载的时候的读取缓冲的大小
 * 返回值 DownloadTaskBuilder类型 构建DownloadTask的构建类
 */
public func setReadBufferSize(readBufferSize:Int64):DownloadTaskBuilder

```


```
/*
 * 设置刷新缓冲大小
 * 参数 Int64类型 刷缓冲的大小
 * 返回值 DownloadTaskBuilder类型 构建DownloadTask的构建类
 */
public func setFlushBufferSize(flushBufferSize:Int64):DownloadTaskBuilder

```


```
/*
 * 用于构造DownloadTask对象
 * 返回值 DownloadTask类型 构建的DownloadTask对象
 */
public func build():DownloadTask

```


#### class DownloadTask

```
/*
 * 用于执行同步下载
 * 参数 DownloadListener类型 下载的时候的监听类
 */
 public func execute(listener:DownloadListener)

 ```


 ```
/*
 * 用于执行异步下载
 * 参数 DownloadListener类型 下载的时候的监听类
 */
 public func enqueue(listener:DownloadListener)

 ```


 ```
/*
 * 用于执行异步下载多个任务
 * 参数 Array<DownloadTask>类型 要下载的任务的数组
 * 参数 DownloadListener类型 下载的时候的监听类
 */
 public static func enqueues(tasks:Array<DownloadTask>,listener:DownloadListener)

 ```


 ```
/*
 * 获取任务的Id
 * 返回值 Int64类型 任务的id
 */
public func getId():Int64

```


```
/*
 * 获取文件名
 * 返回值 Option<String>类型 获得文件的名字
 */
public func getFilename():Option<String>

```


```
/*
 * 获取文件下载路径
 * 返回值 String类型 获取文件的下载url路径
 */
public func getUrl():String

```


```
/*
 * 获取下载下来的文件的父文件夹
 * 返回值 URL类型 文件的文件夹对应的URL
 */
public func getUri():URL

```


```
/*
 * 获取下载后的文件
 * 返回值 File类型 下载后的文件对象
 */
public func getProvidedPathFile():File

```


```
/*
 * 获取读取文件的缓存大小
 * 返回值 Int64类型 获取下载时候的读取缓冲大小
 */
public func getReadBufferSize():Int64

```


```
/*
 * 获取刷新的缓冲大小
 * 返回值 Int64类型 获取下载写入时候的冲刷缓冲大小
 */
public func getFlushBufferSize():Int64

```


```
/*
 * 获取下载时候的连接数
 * 返回值Int64类型,获取下载连接数
 */
public func getConnectionCount():Int64

```


#### interface DownloadListener


```
/*
 * 任务刚开始的回调
 * 参数 DownloadTask类型 下载的任务对象
 */
 func taskStart(task:DownloadTask)

```


```
/*
 * 任务开始尝试连接的回调
 * 参数 DownloadTask类型 下载的任务对象
 * 参数 HashMap<String, ArrayList<String>>类型 请求的header
 */
 func connectTrialStart(task:DownloadTask,requestHeaderFields:HashMap<String, ArrayList<String>>)

```


```
/*
 * 任务结束尝试连接的回调
 * 参数 DownloadTask类型 下载的任务对象
 * 参数 Int64类型 请求返回的响应码
 * 参数 HashMap<String, ArrayList<String>>类型 响应的haeder
 */
 func connectTrialEnd(task:DownloadTask,responseCode:Int64,responseHeaderFields:HashMap<String, ArrayList<String>>)

```


```
/*
 * 从开始下载的回调
 * 参数 DownloadTask类型 下载的任务对象
 */
 func downloadFromBeginning(task:DownloadTask)

```


```
/*
 * 从断点处下载的回调
 * 参数 DownloadTask类型 下载的任务对象
 */
 func downloadFromBreakpoint(task:DownloadTask)

```


```
/*
 * 连接开始的回调
 * 参数 DownloadTask类型 下载的任务对象
 * 参数 Int64类型 对应的分块index
 * 参数 HashMap<String, ArrayList<String>>类型 请求的请求头
 */
 func connectStart(task:DownloadTask,blockIndex:Int64,requestHeaderFields:HashMap<String, ArrayList<String>>)

 ```


```
/*
 * 连接结束的回调
 * 参数 DownloadTask类型 下载的任务对象
 * 参数 Int64类型 对应的分块index
 * 参数 Int64类型 请求返回的响应码
 * 参数 HashMap<String, ArrayList<String>>类型 响应的haeder
 */
 func connectEnd(task:DownloadTask,blockIndex:Int64,responseCode:Int64,responseHeaderFields:HashMap<String, ArrayList<String>>)

 ```


```
/*
 * 开始获取进度的回调
 * 参数 DownloadTask类型 下载的任务对象
 * 参数 Int64类型 对应的分块index
 * 参数 Int64类型 下载的内容长度
 */
 func fetchStart(task:DownloadTask,blockIndex:Int64,contentLength:Int64)

 ```


```
/*
 * 获取进度的回调
 * 参数 DownloadTask类型 下载的任务对象
 * 参数 Int64类型 对应的分块index
 * 参数 Int64类型 下载增加的部分字节数
 */
 func fetchProgress(task:DownloadTask,blockIndex:Int64,increaseBytes:Int64)

```


```
/*
 * 获取进度结束的回调
 * 参数 DownloadTask类型 下载的任务对象
 * 参数 Int64类型 对应的分块index
 * 参数 Int64类型 下载的内容长度
 */
 func fetchEnd(task:DownloadTask,blockIndex:Int64,contentLength:Int64)

```


```
/*
 * 任务结束的回调
 * 参数 DownloadTask类型 下载的任务对象
 * 参数 Option<Exception>类型 造成异常结束的原因
 */
 func taskEnd(task:DownloadTask,realCause:Option<Exception>)

```

