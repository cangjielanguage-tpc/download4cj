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
    func testgetProvidedPathFile01(): Unit {
        var url:String = "https://nodejs.org/dist/v11.2.0/node-v11.2.0.tar.gz"
        let dir=Directory.create("download",recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        task.execute(MyListen())
        var length=task.getProvidedPathFile().getOrThrow().info.length
        var path01=task.getProvidedPathFile().getOrThrow().info.path.fileName.getOrThrow()
        @Assert(length,36508574)
        @Assert(path01,"node-v11.2.0.tar.gz")
    }
}