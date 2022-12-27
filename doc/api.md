### 接口说明

主要是核心类和成员函数说明

#### class DownloadTaskBuilder


```
/**
 * 用于构造DownloadTaskBuilder对象
 *
 * @since 0.34.3
 */
public init(url:String,file:Directory)
```

```
/**
 * 用于设置下载文件的名称
 *
 * @since 0.34.3
 */
public func setFilename(filename:String):DownloadTaskBuilder
```


```
/**
 * 设置下载完成后是否要重新下载
 *
 * @since 0.34.3
 */
public func setPassIfAlreadyCompleted(passIfAlreadyCompleted:Bool):DownloadTaskBuilder
```


```
/**
 * 设置进度回调的时间间隔
 *
 * @since 0.34.3
 */
public func setMinIntervalMillisCallbackProcess(passIfAlreadyCompleted:Bool):DownloadTaskBuilder
```

```
/**
 * 设置读取缓存大小
 *
 * @since 0.34.3
 */
public func setReadBufferSize(readBufferSize:Int64):DownloadTaskBuilder
```


```
/**
 * 设置刷新缓冲大小
 *
 * @since 0.34.3
 */
public func setFlushBufferSize(flushBufferSize:Int64):DownloadTaskBuilder
```


```
/**
 * 用于构造DownloadTask对象
 *
 * @since 0.34.3
 */
public func build():DownloadTask
```



#### class DownloadTask


```
/**
 * 用于执行同步下载
 *
 * @since 0.34.3
 */
 public func execute(listener:DownloadListener):Unit
 ```


 ```
/**
 * 获取任务的Id
 *
 * @since 0.34.3
 */
public func getId():Int64
```

 ```
/**
 * 获取文件名
 *
 * @since 0.34.3
 */
public func getFilename():Option<String>
```

 ```
/**
 * 获取文件下载路径
 *
 * @since 0.34.3
 */
public func getUrl():String
```


 ```
/**
 * 获取下载下来的文件的父文件夹
 *
 * @since 0.34.3
 */
public func getUri():URL
```

 ```
/**
 * 获取下载后的文件
 *
 * @since 0.34.3
 */
public func getProvidedPathFile():File
```

 ```
/**
 * 获取读取文件的缓存大小
 *
 * @since 0.34.3
 */
public func getReadBufferSize():Int64
```


 ```
/**
 * 获取刷新的缓冲大小
 *
 * @since 0.34.3
 */
public func getFlushBufferSize():Int64
```

 ```
/**
 * 获取下载时候的连接数
 *
 * @since 0.34.3
 */
public func getConnectionCount():Int64
```


#### interface DownloadListener


```
/**
 * 任务刚开始的回调
 *
 * @since 0.34.3
 */
 func taskStart(task:DownloadTask):Unit
 ```



 ```
/**
 * 任务开始尝试连接的回调
 *
 * @since 0.34.3
 */
 func connectTrialStart(task:DownloadTask,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit
 ```


```
/**
 * 任务结束尝试连接的回调
 *
 * @since 0.34.3
 */
 func connectTrialEnd(task:DownloadTask,responseCode:Int64,responseHeaderFields:HashMap<String, ArrayList<String>>):Unit
 ```


 ```
/**
 * 从开始下载的回调
 *
 * @since 0.34.3
 */
 func downloadFromBeginning(task:DownloadTask,info:BreakpointInfo,cause:ResumeFailedCause):Unit
 ```


```
/**
 * 从断点处下载的回调
 *
 * @since 0.34.3
 */
 func downloadFromBreakpoint(task:DownloadTask,info:BreakpointInfo):Unit
 ```


```
/**
 * 连接开始的回调
 *
 * @since 0.34.3
 */
 func connectStart(task:DownloadTask,blockIndex:Int64,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit
 ```



```
/**
 * 连接结束的回调
 *
 * @since 0.34.3
 */
 func connectEnd(task:DownloadTask,blockIndex:Int64,responseCode:Int64,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit
 ```


```
/**
 * 开始获取进度的回调
 *
 * @since 0.34.3
 */
 func fetchStart(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit
 ```


```
/**
 * 获取进度的回调
 *
 * @since 0.34.3
 */
 func fetchProgress(task:DownloadTask,blockIndex:Int64,increaseBytes:Int64):Unit
 ```


```
/**
 * 获取进度结束的回调
 *
 * @since 0.34.3
 */
 func fetchEnd(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit
 ```


 ```
/**
 * 任务结束的回调
 *
 * @since 0.34.3
 */
 func taskEnd(task:DownloadTask,cause:EndCause,realCause:Option<Exception>):Unit
 ```

