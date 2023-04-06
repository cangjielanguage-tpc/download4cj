// 3rd_party_lib:ok-download/build/okdownload:ok-download/build/okhttp:ok-download/build/cryptocj
// dependence:common.cj

from okdownload import okdownload.*
from std import collection.*
from std import fs.*
from std import math.*

@Test
public class Test01{
    public override func beforeEach(): Unit {
         if(Directory.exists("download"))
         {
              Directory.delete("download",recursive:true)
         }
    }
    @TestCase
    func testsetMinIntervalMillisCallbackProcess01(): Unit {
        var url:String = "https://nodejs.org/dist/v11.2.0/node-v11.2.0.tar.gz"
        let dir=Directory.create("download",recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).setMinIntervalMillisCallbackProcess(30)
                                                           .build()
        task.execute(MyListen())
    }
    @TestCase
    func testsetMinIntervalMillisCallbackProcess02(): Unit {
        var url:String = "https://nodejs.org/dist/v11.2.0/node-v11.2.0.tar.gz"
        let dir=Directory.create("download",recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).setMinIntervalMillisCallbackProcess(Int64.Max)
                                                           .build()
        task.execute(MyListen())
    }
    @TestCase
    func testsetMinIntervalMillisCallbackProcess03(): Unit {
        var url:String = "https://nodejs.org/dist/v11.2.0/node-v11.2.0.tar.gz"
        let dir=Directory.create("download",recursive:true)
        var flag=1
        try{
            let task:DownloadTask = DownloadTaskBuilder(url,dir).setMinIntervalMillisCallbackProcess(Int64.Min)
                                                           .build()
        }catch(e:IllegalArgumentException){
            flag=0
        }
        @Assert(flag,0)
    }
    @TestCase
    func testsetMinIntervalMillisCallbackProcess04(): Unit {
        var url:String = "https://nodejs.org/dist/v11.2.0/node-v11.2.0.tar.gz"
        let dir=Directory.create("download",recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).setMinIntervalMillisCallbackProcess(0)
                                                       .build()
        task.execute(MyListen())
    }
    @TestCase
    func testsetMinIntervalMillisCallbackProcess05(): Unit {
        var url:String = "https://nodejs.org/dist/v11.2.0/node-v11.2.0.tar.gz"
        let dir=Directory.create("download",recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        task.execute(MyListen())
    }
}
