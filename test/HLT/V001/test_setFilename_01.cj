// 3rd_party_lib:ok-download/build/okdownload:ok-download/ci_lib/okhttp
// dependence:common.cj

from okdownload import okdownload.*
from std import collection.*
from std import fs.*

@Test
public class Test01{
    public override func beforeEach(): Unit {
         if(Directory.exists("download"))
         {
              Directory.delete("download",recursive:true)
         }
    }
    @TestCase
    func testsetFilename01(): Unit {
        var url:String = "https://nodejs.org/dist/v11.2.0/node-v11.2.0.tar.gz"
        let dir=Directory.create("download",recursive:true)
        let filename="target.tar.gz"
        let task:DownloadTask = DownloadTaskBuilder(url,dir).setFilename(filename).build()
        task.execute(MyListen())
        @Assert(File.exists("download/target.tar.gz"),true)
        var fileInfo=FileInfo("download/target.tar.gz")
        @Assert(fileInfo.length,36508574)
    }
    @TestCase
    func testsetFilename02(): Unit {
        var url:String = "https://nodejs.org/dist/v11.2.0/node-v11.2.0.tar.gz"
        let dir=Directory.create("download",recursive:true)
        let filename="target.gz"
        let task:DownloadTask = DownloadTaskBuilder(url,dir).setFilename(filename).build()
        task.execute(MyListen())
        @Assert(File.exists("download/target.gz"),true)
        var fileInfo=FileInfo("download/target.gz")
        @Assert(fileInfo.length,36508574)
    }
    @TestCase
    func testsetFilename03(): Unit {
        var url:String = "https://nodejs.org/dist/v11.2.0/node-v11.2.0.tar.gz"
        let dir=Directory.create("download",recursive:true)
        let filename="target.tar"
        let task:DownloadTask = DownloadTaskBuilder(url,dir).setFilename(filename).build()
        task.execute(MyListen())
        @Assert(File.exists("download/target.tar"),true)
        var fileInfo=FileInfo("download/target.tar")
        @Assert(fileInfo.length,36508574)
    }
    @TestCase
    func testsetFilename04(): Unit {
        var url:String = "https://nodejs.org/dist/v11.2.0/node-v11.2.0.tar.gz"
        let dir=Directory.create("download",recursive:true)
        let filename="target"
        let task:DownloadTask = DownloadTaskBuilder(url,dir).setFilename(filename).build()
        task.execute(MyListen())
        @Assert(File.exists("download/target"),true)
        var fileInfo=FileInfo("download/target")
        @Assert(fileInfo.length,36508574)
    }
    @TestCase
    func testsetFilename05(): Unit {
        var url:String = "https://nodejs.org/dist/v11.2.0/node-v11.2.0.tar.gz"
        let dir=Directory.create("download",recursive:true)
        let filename="node-v11.2.0.tar.gz"
        let task:DownloadTask = DownloadTaskBuilder(url,dir).setFilename(filename).build()
        task.execute(MyListen())
        @Assert(File.exists("download/node-v11.2.0.tar.gz"),true)
        var fileInfo=FileInfo("download/node-v11.2.0.tar.gz")
        @Assert(fileInfo.length,36508574)
    }
}