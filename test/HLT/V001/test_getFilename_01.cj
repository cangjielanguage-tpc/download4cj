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
    func testgetFilename01(): Unit {
        var url:String = "https://nodejs.org/dist/v11.2.0/node-v11.2.0.tar.gz"
        let dir=Directory.create("download",recursive:true)
        let filename="target"
        let task:DownloadTask = DownloadTaskBuilder(url,dir).setFilename(filename).build()
        var taskFilename=task.getFilename().getOrThrow()
        @Assert(taskFilename,filename)
    }

    @TestCase
    func testgetFilename02(): Unit {
        var url:String = "https://nodejs.org/dist/v11.2.0/node-v11.2.0.tar.gz"
        let dir=Directory.create("download",recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        task.execute(MyListen())
        var taskFilename=task.getFilename().getOrThrow()
        @Assert(taskFilename,"node-v11.2.0.tar.gz")
    }
}
