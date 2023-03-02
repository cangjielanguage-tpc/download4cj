<div align="center">
<h1>OkDownLoad</h1>
</div>


<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v0.0.2-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v0.36.4-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-85.7%25-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/project-open-brightgreen" style="display: inline-block;" />
</p>


## <img alt="" src="./doc/assets/readme-icon-introduction.png" style="display: inline-block;" width=3%/> 介绍
可靠、灵活、快速和强大的下载引擎。提供同步下载,异步下载
参考地址 https://github.com/lingochamp/okdownload.git

### 特性

- 🚀 支持多线程下载

- 🚀 纯仓颉开发，无额外引用

- 🚀 支持同步下载和异步下载

## <img alt="" src="./doc/assets/readme-icon-framework.png" style="display: inline-block;" width=3%/> 软件架构

### 架构图

<p align="center">
<img src="./doc/assets/okdownloadclassrelation.png" width="40%" >
<img src="./doc/assets/okdownloadclassshuoming.png" width="40%" >
</p>


### 源码目录
```shell
.
├── CHANGELOG.md
├── gitee_gate.cfg
├── LICENSE
├── module.json
├── README.md
├── README.OPENSOURCE
├── doc
│  ├── assets
│  ├── cjcov
│  ├── api.md
│  ├── design.md
│  ├── OkDownLoad核心类说明.xmind
│  └── OkDownLoad类关系图.xmind
├── src
│  ├── BreakpointInterceptor.cj
│  ├── BreakPointLocalCheck.cj
│  ├── BreakPointLocalCheck.cj
│  ├── ......cj
│  ├── DownloadTask.cj
│  ├── DownloadCall.cj
│  ├── DownloadChain.cj
│  ├── DownloadListener.cj
│  ├── DownloadDispatcher.cj
│  ├── DownloadStrategy.cj
│  ├── OkDownload.cj
│  ├── DownloadStore.cj
│  ├── DownloadOutputStream.cj
│  └── DownloadConnection.cj
└── test
```
- `doc`  包含库的图片资源，覆盖率报告，api文档，设计文档，核心类说明和类关系图
- `src`  okdownload项目的源码目录
- `test` 示例代码目录，里面存放了测试用例

### 接口说明

主要是核心类和成员函数说明，详情请见  [设计文档](./doc/design.md)

## <img alt="" src="./doc/assets/readme-icon-compile.png" style="display: inline-block;" width=3%/> 使用说明

### 编译

#### Linux编译

```
git clone https://gitee.com/HW-PLLab/ok-download.git
地址：https://gitee.com/HW-PLLab/testJekins 将 src 下 ci_test 放入 ok-download 根目录下
python3 ci_test/main.py build
```

#### Windows编译

```
1.获取最新tag的okdownload代码
2.配置依赖库
  (1)在src同级目录下创建okhttp文档，根据okdownload/module.json文件中指定的okhttp版本获取okhttp代码
  (2)根据okhttp库介绍编译okhttp库
3.编译ok-download
  (1)切换到okdownload下，即src同级目录，执行如下命令，提示success即表示编译成功
     cpm build
```


### 功能示例

####  同步下载示例

```

from okdownload import okdownload.*
from std import collection.*
from std import fs.*

var isComplete = false

main(){

        var url:String = "http://imgsrc.baidu.com/forum/w%3D580/sign=eed1753686d6277fe9123230183a1f63/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"
        let parentFilePath:Path = Path("./fileDownLoad")
        var parentFile:Option<Directory> = Option<Directory>.None
        if (!Directory.exists(parentFilePath)) {
            parentFile = Directory.create(parentFilePath, recursive: true)
        }
        let task:DownloadTask = DownloadTaskBuilder(url, parentFile.getOrThrow())
            .setMinIntervalMillisCallbackProcess(30)
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

####  异步下载示例

```

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


## <img alt="" src="./doc/assets/readme-icon-contribute.png" style="display: inline-block;" width=3%/> 参与贡献

欢迎给我们提交PR，欢迎给我们提交Issue，欢迎参与任何形式的贡献。

