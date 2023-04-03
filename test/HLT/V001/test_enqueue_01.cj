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
    func testEnqueue01(): Unit {
        var url:String = "http://imgsrc.baidu.com/forum/w%3D580/sign=eed1753686d6277fe9123230183a1f63/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"
        var dir=Directory.create("download",recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        task.enqueue(MyListen())
        sleep(3*1000*1000*1000)
        @Assert(File.exists("download/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"),true)
        @Assert(FileInfo("download/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg").length,38662)
    }
}
