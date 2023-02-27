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
    public func testMyListen01(): Unit {
        var url:String = "http://imgsrc.baidu.com/forum/w%3D580/sign=eed1753686d6277fe9123230183a1f63/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"
        let dir=Directory.create("download",recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        let listener01=MyListen()
        task.execute(listener01)
        @Assert(listener01.flag01,1)
        @Assert(listener01.flag02,1)
        @Assert(listener01.flag03,1)
        @Assert(listener01.flag04,1)
        @Assert(listener01.flag05,0)
        @Assert(listener01.flag06,1)
        @Assert(listener01.flag07,1)
        @Assert(listener01.flag08,1)
        @Assert(listener01.flag09,1)
        @Assert(listener01.flag10,1)
        @Assert(listener01.flag11,1)
    }
}
