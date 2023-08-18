// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
from download4cj import download4cj.*
from std import collection.*
from std import fs.*
from std import sync.*
from std import time.*
from std import math.*
public let big_file_url="https://cdn.llscdn.com/yy/files/xs8qmxn8-lls-LLS-5.8-800-20171207-111607.apk"
public let big_file_size=43994005
public let big_file_name="xs8qmxn8-lls-LLS-5.8-800-20171207-111607.apk"
public let small_file_url="http://imgsrc.baidu.com/forum/w%3D580/sign=eed1753686d6277fe9123230183a1f63/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"
public let small_file_size=38662
public let small_file_name="9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"
public class MyListen<: DownloadListener{
    public var flag01=0
    public var flag02=0
    public var flag03=0
    public var flag04=0
    public var flag05=0
    public var flag06=0
    public var flag07=0
    public var flag08=0
    public var flag09=0
    public var flag10=0
    public var flag11=0
    public func taskStart(task:DownloadTask):Unit{
         task.getUrl()
         flag01=1
    }
    public func connectTrialStart(task:DownloadTask,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
         task.getUrl()
         requestHeaderFields.size
         flag02=1
    }
    public func connectTrialEnd(task:DownloadTask,responseCode:Int64,responseHeaderFields:HashMap<String, ArrayList<String>>):Unit{
         task.getUrl()
         responseHeaderFields.size
         responseCode.toString()
         flag03=1
    }
    public func downloadFromBeginning(task:DownloadTask):Unit{
         task.getUrl()
         flag04=1
    }
    public func downloadFromBreakpoint(task:DownloadTask):Unit{
         task.getUrl()
         flag05=1
    }
    public func connectStart(task:DownloadTask,blockIndex:Int64,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
         task.getUrl()
         blockIndex.toString()
         requestHeaderFields.toString()
         flag06=1
    }
    public func connectEnd(task:DownloadTask,blockIndex:Int64,responseCode:Int64,requestHeaderFields:HashMap<String, ArrayList<String>>):Unit{
         task.getUrl()
         blockIndex.toString()
         responseCode.toString()
         requestHeaderFields.toString()
         flag07=1
    }
    public func fetchStart(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit{
         task.getUrl()
         blockIndex.toString()
         contentLength.toString()
         flag08=1
    }
    public func fetchProgress(task:DownloadTask,blockIndex:Int64,increaseBytes:Int64):Unit{
         task.getUrl()
         blockIndex.toString()
         increaseBytes.toString()
         flag09=1
    }
    public func fetchEnd(task:DownloadTask,blockIndex:Int64,contentLength:Int64):Unit{
         task.getUrl()
         blockIndex.toString()
         contentLength.toString()
         flag10=1
    }
    public func taskEnd(task:DownloadTask,realCause:Option<Exception>):Unit{
         task.getUrl()
         realCause is Option<Exception>
         flag11=1
    }
}
