// 3rd_party_lib:ok-download/build/okdownload:ok-download/build/okhttp:ok-download/build/cryptocj
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
    func testuse01(): Unit {
        var url:String = "https://nodejs.org/dist/v11.2.0/node-v11.2.0.tar.gz"
        let dir=Directory.create("download",recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        task.execute(MyListen())
        @Assert(File.exists("download/node-v11.2.0.tar.gz"),true)
        var fileInfo=FileInfo("download/node-v11.2.0.tar.gz")
        @Assert(fileInfo.length,36508574)
    }
    @TestCase
    func testuse02(): Unit {
        var url:String = "https://nodejs.org/dist"
        let dir=Directory.create("download",recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        @Assert(File.exists("download/dist"),false)
        var flag=1
        try{
            task.execute(MyListen())
        }catch(e:Exception){
            flag=0
        }
        @Assert(flag,0)
    }
}
