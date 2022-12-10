### 三方库设计说明

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
| setFilename   | filename:String | DownloadTaskBuilder | 用于设置下载文件的名称 |
| setPassIfAlreadyCompleted   | passIfAlreadyCompleted:Bool | DownloadTaskBuilder | 设置下载完成后是否要重新下载|
| setMinIntervalMillisCallbackProcess   | minIntervalMillisCallbackProcess:Int64 | DownloadTaskBuilder | 设置进度回调的时间间隔 |


💡 DownloadTask 任务对象类

| 成员函数 | 入参 | 返回值 | 作用描述 |
| --- | --- | --- | --- |
| execute   | listener:DownloadListener | Unit | 用于执行同步下载 |
| getId   | 无 | Int64 | 获取任务的Id|
| getFilename   | 无 | Option<String> | 获取文件名 |
| getUrl   | 无 | String | 获取文件下载路径 |
| getUri   | 无 | URL | 获取下载下来的文件的父文件夹 |
| getProvidedPathFile   | 无 | File | 获取下载后的文件 |
| getReadBufferSize   | 无 | Int64 | 获取读取文件的缓存大小 |
| getFlushBufferSize   | 无 | Int64 | 获取刷新的缓冲大小 |
| getConnectionCount   | 无 | Int64 | 获取下载时候的连接数 |


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
         // do re-download even if the task has already been completed in the past.
         .setPassIfAlreadyCompleted(false)
         .build()

     task.execute(DefaultTransmitListener())

}
```

#### 🚀 6 架构图

<img alt="" src="./assets/okdownloadclassrelation.png" style="display: inline-block;" width=60%/>
<img alt="" src="./assets/okdownloadclassshuoming.png" style="display: inline-block;" width=60%/>

