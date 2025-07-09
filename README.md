<div align="center">
<h1>DownLoad4cj</h1>
</div>


<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v1.0.3-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v1.0.0-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-85.4%25-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/project-open-brightgreen" style="display: inline-block;" />
</p>


## <img alt="" src="./doc/assets/readme-icon-introduction.png" style="display: inline-block;" width=3%/> 介绍
可靠、灵活、快速和强大的下载引擎。提供同步下载,异步下载,暂停任务

### 特性

- 🚀 支持多线程下载

- 🚀 纯仓颉开发，无额外引用

- 🚀 支持同步下载和异步下载

- 🚀 支持暂停任务

## <img alt="" src="./doc/assets/readme-icon-framework.png" style="display: inline-block;" width=3%/> 软件架构

### 架构图

<p align="center">
<img src="./doc/assets/download4cjclassrelation.png" width="40%" >
<img src="./doc/assets/download4cjclassshuoming.png" width="40%" >
<img src="./doc/assets/download4cjcancel.png" width="40%" >
</p>


### 源码目录
```shell
.
├── CHANGELOG.md
├── LICENSE
├── README.md
├── README.OPENSOURCE
├── doc
│  ├── assets
│  └── feaure_api.md
├── src
│  └── download4cj
└── test
```
- `doc`  包含库的图片资源，feature_api文档
- `src`  download4cj项目的源码目录
- `test` 示例代码目录，里面存放了测试用例

### 接口说明

主要是核心类和成员函数说明，详情请见  [设计文档](./doc/feature_api.md)

## <img alt="" src="./doc/assets/readme-icon-compile.png" style="display: inline-block;" width=3%/> 使用说明

### 编译

#### Linux编译

```
cjpm build
```

#### Windows编译

```
cjpm build
```


### 功能示例

####  同步下载示例

```
import download4cj.*
import std.collection.*
import std.fs.*

var isComplete = false

main() {
    var url: String = "http://127.0.0.1/test.jpg"
    let parentFilePath: Path = Path("./fileDownLoad")
    if (!exists(parentFilePath)) {
        Directory.create(parentFilePath, recursive: true)
    }
    let task: DownloadTask = DownloadTaskBuilder(url, parentFilePath).setMinIntervalMillisCallbackProcess(30).build()
    task.execute(MyListen())
    if (isComplete) {
        println(isComplete)
        return 0
    } else {
        return 1
    }
}

public class MyListen <: DownloadListener {
    public func taskStart(task: DownloadTask): Unit {
    }

    public func connectTrialStart(task: DownloadTask, requestHeaderFields: HashMap<String, ArrayList<String>>): Unit {
    }

    public func connectTrialEnd(task: DownloadTask, responseCode: Int64, responseHeaderFields: HashMap<String, ArrayList<String>>): Unit {
    }

    public func downloadFromBeginning(task: DownloadTask): Unit {
    }

    public func downloadFromBreakpoint(task: DownloadTask): Unit {
    }

    public func connectStart(task: DownloadTask, blockIndex: Int64, requestHeaderFields: HashMap<String, ArrayList<String>>): Unit {
    }

    public func connectEnd(task: DownloadTask, blockIndex: Int64, responseCode: Int64, requestHeaderFields: HashMap<String, ArrayList<String>>): Unit {
    }

    public func fetchStart(task: DownloadTask, blockIndex: Int64, contentLength: Int64): Unit {
    }

    public func fetchProgress(task: DownloadTask, blockIndex: Int64, increaseBytes: Int64): Unit {
    }

    public func fetchEnd(task: DownloadTask, blockIndex: Int64, contentLength: Int64): Unit {
    }

    public func taskEnd(task: DownloadTask, realCause: Option<Exception>): Unit {
        isComplete = true
    }
}
```

执行结果如下：

```shell

true

```

####  异步下载示例

```
import download4cj.*
import std.collection.*
import std.fs.*

var isComplete = false

main() {
    var url: String = "http://127.0.0.1/test.jpg"
    let lastIndex: Int64 = url.lastIndexOf(".").getOrThrow()
    var FileEnds = url[lastIndex..]
    let filenamePre: String = "single-test"
    let filename = filenamePre + FileEnds
    let parentFilePath: Path = Path("./fileDownLoad0")
    if (!exists(parentFilePath)) {
        Directory.create(parentFilePath, recursive: true)
    }
    let task: DownloadTask = DownloadTaskBuilder(url, parentFilePath)
        .setFilename(filename)
        .setMinIntervalMillisCallbackProcess(30)
        .build()
    task.enqueue(MyListen())
    sleep(Duration.second * 3)
    if (isComplete) {
        println(isComplete)
        return 0
    } else {
        return 1
    }
}

public class MyListen <: DownloadListener {
    public func taskStart(task: DownloadTask): Unit {
    }

    public func connectTrialStart(task: DownloadTask, requestHeaderFields: HashMap<String, ArrayList<String>>): Unit {
    }

    public func connectTrialEnd(task: DownloadTask, responseCode: Int64, responseHeaderFields: HashMap<String, ArrayList<String>>): Unit {
    }

    public func downloadFromBeginning(task: DownloadTask): Unit {
    }

    public func downloadFromBreakpoint(task: DownloadTask): Unit {
    }

    public func connectStart(task: DownloadTask, blockIndex: Int64, requestHeaderFields: HashMap<String, ArrayList<String>>): Unit {
    }

    public func connectEnd(task: DownloadTask, blockIndex: Int64, responseCode: Int64, requestHeaderFields: HashMap<String, ArrayList<String>>): Unit {
    }

    public func fetchStart(task: DownloadTask, blockIndex: Int64, contentLength: Int64): Unit {
    }

    public func fetchProgress(task: DownloadTask, blockIndex: Int64, increaseBytes: Int64): Unit {
    }

    public func fetchEnd(task: DownloadTask, blockIndex: Int64, contentLength: Int64): Unit {
    }

    public func taskEnd(task: DownloadTask, realCause: Option<Exception>): Unit {
        isComplete = true
    }
}
```


执行结果如下：

```shell

true

```


#### 同步下载暂停下载示例

```cangjie
import download4cj.*
import std.collection.*
import std.fs.*

var isComplete = false

main() {
    var url: String = "http://127.0.0.1/test.apk"
    let filename: String = "single-test"
    let parentFilePath: Path = Path("./fileDownLoad")
    if (!exists(parentFilePath)) {
        Directory.create(parentFilePath, recursive: true)
    } else {
    }

    let task: DownloadTask = DownloadTaskBuilder(url, parentFilePath).setMinIntervalMillisCallbackProcess(30).build()

    spawn {
        =>
        sleep(Duration.second)
        task.cancel()
        let blockList: ArrayList<BlockInfo> = task.getBlockInfoList().getOrThrow()
        for (oneitem in blockList) {
            println("==========================================================")
            println("blockinfoCurrent=" + oneitem.getCurrentOffset().toString() + "=========blockinfoContent=" + oneitem.getContentLength().toString())
            println("blockinfoRangeLeft=" + oneitem.getRangeLeft().toString() + "=========blockinfoRangeRight=" + oneitem.getRangeRight().toString())
            println("==========================================================")
        }
    }
    task.execute(MyListen())
    sleep(Duration.second * 3)
    task.execute(MyListen())
    sleep(Duration.second * 3)

    if (isComplete && task.getConnectionCount() == 3) {
        println(true)
        return 0
    } else {
        println(false)
        return 1
    }
}

public class MyListen <: DownloadListener {
    public func taskStart(task: DownloadTask): Unit {
    }

    public func connectTrialStart(task: DownloadTask, requestHeaderFields: HashMap<String, ArrayList<String>>): Unit {
    }

    public func connectTrialEnd(task: DownloadTask, responseCode: Int64, responseHeaderFields: HashMap<String, ArrayList<String>>): Unit {
    }

    public func downloadFromBeginning(task: DownloadTask): Unit {
    }

    public func downloadFromBreakpoint(task: DownloadTask): Unit {
    }

    public func connectStart(task: DownloadTask, blockIndex: Int64, requestHeaderFields: HashMap<String, ArrayList<String>>): Unit {
    }

    public func connectEnd(task: DownloadTask, blockIndex: Int64, responseCode: Int64, requestHeaderFields: HashMap<String, ArrayList<String>>): Unit {
    }

    public func fetchStart(task: DownloadTask, blockIndex: Int64, contentLength: Int64): Unit {
    }

    public func fetchProgress(task: DownloadTask, blockIndex: Int64, increaseBytes: Int64): Unit {
    }

    public func fetchEnd(task: DownloadTask, blockIndex: Int64, contentLength: Int64): Unit {
    }

    public func taskEnd(task: DownloadTask, realCause: Option<Exception>): Unit {
        isComplete = true
    }
}
```

执行结果如下：

```shell

true

```



#### 异步下载暂停下载示例


```cangjie
import download4cj.*
import std.collection.*
import std.fs.*

var isComplete = false

main() {
    var url: String = "http://127.0.0.1/test.apk"
    let filename: String = "single-test"
    let parentFilePath: Path = Path("./fileDownLoad")
    if (!exists(parentFilePath)) {
        Directory.create(parentFilePath, recursive: true)
    } else {
    }

    let task: DownloadTask = DownloadTaskBuilder(url, parentFilePath)
        .setMinIntervalMillisCallbackProcess(30)
        .build()
    task.enqueue(MyListen())
    sleep(Duration.second)
    task.cancel()

    let blockList: ArrayList<BlockInfo> = task.getBlockInfoList().getOrThrow()
    for (oneitem in blockList) {
        println("==========================================================")
        println("blockinfoCurrent=" + oneitem.getCurrentOffset().toString() + "=========blockinfoContent=" + oneitem.getContentLength().toString())
        println("blockinfoRangeLeft=" + oneitem.getRangeLeft().toString() + "=========blockinfoRangeRight=" + oneitem.getRangeRight().toString())
        println("==========================================================")
    }

    sleep(Duration.second * 2)
    task.enqueue(MyListen())
    sleep(Duration.second * 3)
    if (isComplete && task.getConnectionCount() == 3) {
        println(true)
        return 0
    } else {
        println(false)
        return 1
    }
}

public class MyListen <: DownloadListener {
    public func taskStart(task: DownloadTask): Unit {
    }

    public func connectTrialStart(task: DownloadTask, requestHeaderFields: HashMap<String, ArrayList<String>>): Unit {
    }

    public func connectTrialEnd(task: DownloadTask, responseCode: Int64, responseHeaderFields: HashMap<String, ArrayList<String>>): Unit {
    }

    public func downloadFromBeginning(task: DownloadTask): Unit {
    }

    public func downloadFromBreakpoint(task: DownloadTask): Unit {
    }

    public func connectStart(task: DownloadTask, blockIndex: Int64, requestHeaderFields: HashMap<String, ArrayList<String>>): Unit {
    }

    public func connectEnd(task: DownloadTask, blockIndex: Int64, responseCode: Int64, requestHeaderFields: HashMap<String, ArrayList<String>>): Unit {
    }

    public func fetchStart(task: DownloadTask, blockIndex: Int64, contentLength: Int64): Unit {
    }

    public func fetchProgress(task: DownloadTask, blockIndex: Int64, increaseBytes: Int64): Unit {
    }

    public func fetchEnd(task: DownloadTask, blockIndex: Int64, contentLength: Int64): Unit {
    }

    public func taskEnd(task: DownloadTask, realCause: Option<Exception>): Unit {
        isComplete = true
    }
}
```

执行结果如下：

```shell

true

```


####  异步下载多个文件暂停下载示例

```cangjie
import download4cj.*
import std.collection.*
import std.fs.*

var isComplete = false

main() {
    var url1: String = "http://127.0.0.1/test.jpg"
    var url2: String = "http://127.0.0.1/test.zip"
    var url3: String = "http://127.0.0.1/test2.zip"

    let lastIndex1: Int64 = url1.lastIndexOf(".").getOrThrow()
    let lastIndex2: Int64 = url2.lastIndexOf(".").getOrThrow()
    let lastIndex3: Int64 = url3.lastIndexOf(".").getOrThrow()
    var FileEnds1 = url1[lastIndex1..]
    var FileEnds2 = url2[lastIndex2..]
    var FileEnds3 = url3[lastIndex3..]

    let filenamePre: String = "single-test"
    let filename1 = filenamePre + "111" + FileEnds1
    let filename2 = filenamePre + "222" + FileEnds2
    let filename3 = filenamePre + "333" + FileEnds3

    let parentFilePath: Path = Path("./fileDownLoad0")
    if (!exists(parentFilePath)) {
        Directory.create(parentFilePath, recursive: true)
    } else {
    }

    let task1: DownloadTask = DownloadTaskBuilder(url1, parentFilePath)
        .setFilename(filename1)
        .setMinIntervalMillisCallbackProcess(30)
        .build()

    let task2: DownloadTask = DownloadTaskBuilder(url2, parentFilePath)
        .setFilename(filename2)
        .setMinIntervalMillisCallbackProcess(30)
        .build()

    let task3: DownloadTask = DownloadTaskBuilder(url3, parentFilePath)
        .setFilename(filename3)
        .setMinIntervalMillisCallbackProcess(30)
        .build()

    let tasklists: ArrayList<DownloadTask> = ArrayList<DownloadTask>()
    tasklists.add(task1)
    tasklists.add(task2)
    tasklists.add(task3)
    let tasks: Array<DownloadTask> = tasklists.toArray()

    DownloadTask.enqueues(tasks, MyListen())
    sleep(Duration.second * 2)
    DownloadTask.cancels(tasks)

    for (oneTask in tasks) {
        println("==========================================================")
        let blockList: ArrayList<BlockInfo> = oneTask.getBlockInfoList().getOrThrow()
        for (oneitem in blockList) {
            println("blockinfoCurrent=" + oneitem.getCurrentOffset().toString() + "=========blockinfoContent=" + oneitem.getContentLength().toString())
            println("blockinfoRangeLeft=" + oneitem.getRangeLeft().toString() + "=========blockinfoRangeRight=" + oneitem.getRangeRight().toString())
        }
        println("==========================================================")
    }

    sleep(Duration.second * 2)
    DownloadTask.enqueues(tasks, MyListen())
    sleep(Duration.second * 30)
    if (isComplete) {
        println(true)
        return 0
    } else {
        println(false)
        return 1
    }
}

public class MyListen <: DownloadListener {
    public func taskStart(task: DownloadTask): Unit {
    }

    public func connectTrialStart(task: DownloadTask, requestHeaderFields: HashMap<String, ArrayList<String>>): Unit {
    }

    public func connectTrialEnd(task: DownloadTask, responseCode: Int64, responseHeaderFields: HashMap<String, ArrayList<String>>): Unit {
    }

    public func downloadFromBeginning(task: DownloadTask): Unit {
    }

    public func downloadFromBreakpoint(task: DownloadTask): Unit {
    }

    public func connectStart(task: DownloadTask, blockIndex: Int64, requestHeaderFields: HashMap<String, ArrayList<String>>): Unit {
    }

    public func connectEnd(task: DownloadTask, blockIndex: Int64, responseCode: Int64, requestHeaderFields: HashMap<String, ArrayList<String>>): Unit {
    }

    public func fetchStart(task: DownloadTask, blockIndex: Int64, contentLength: Int64): Unit {
    }

    public func fetchProgress(task: DownloadTask, blockIndex: Int64, increaseBytes: Int64): Unit {
    }

    public func fetchEnd(task: DownloadTask, blockIndex: Int64, contentLength: Int64): Unit {
    }

    public func taskEnd(task: DownloadTask, realCause: Option<Exception>): Unit {
        isComplete = true
    }
}
```

执行结果如下：

```shell

true

```

## 开源协议

本项目基于 [Apache License 2.0](./LICENSE) ，请自由的享受和参与开源。


## <img alt="" src="./doc/assets/readme-icon-contribute.png" style="display: inline-block;" width=3%/> 参与贡献

欢迎给我们提交PR，欢迎给我们提交Issue，欢迎参与任何形式的贡献。

