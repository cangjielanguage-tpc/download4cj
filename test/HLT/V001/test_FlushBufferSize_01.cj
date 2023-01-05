// 3rd_party_lib:ok-download/build/okdownload:ok-download/ci_lib/okhttp

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
    func testgetFlushBufferSize01(): Unit {
        var url:String = "https://nodejs.org/dist/v11.2.0/node-v11.2.0.tar.gz"
        let dir=Directory.create("download",recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        var flushBufferSize=task.getFlushBufferSize()
        @Assert(flushBufferSize,16*1024)
    }
    @TestCase
    func testgetFlushBufferSize02(): Unit {
        var url:String = "https://nodejs.org/dist/v11.2.0/node-v11.2.0.tar.gz"
        let dir=Directory.create("download",recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).setFlushBufferSize(Int64.Max).build()
        var flushBufferSize=task.getFlushBufferSize()
        @Assert(flushBufferSize,Int64.Max)
    }
    @TestCase
    func testgetFlushBufferSize03(): Unit {
        var url:String = "https://nodejs.org/dist/v11.2.0/node-v11.2.0.tar.gz"
        let dir=Directory.create("download",recursive:true)
        var flag=1
        try{
            let task:DownloadTask = DownloadTaskBuilder(url,dir).setFlushBufferSize(0).build()
        }catch(e:IllegalArgumentException){
            flag=0
        }
        @Assert(flag,0)
    }
    @TestCase
    func testgetFlushBufferSize04(): Unit {
        var url:String = "https://nodejs.org/dist/v11.2.0/node-v11.2.0.tar.gz"
        let dir=Directory.create("download",recursive:true)
        var flag=1
        try{
            let task:DownloadTask = DownloadTaskBuilder(url,dir).setFlushBufferSize(Int64.Min).build()
        }catch(e:IllegalArgumentException){
            flag=0
        }
        @Assert(flag,0)
    }
}