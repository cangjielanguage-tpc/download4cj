// 3rd_party_lib:ok-download/build/okdownload:ok-download/ci_lib/okhttp
// dependence:common.cj

from okdownload import okdownload.*
from std import collection.*
from std import fs.*

@Test
public class Test02{
    public override func beforeEach(): Unit {
         var dirs=Array<String>(["download01","download02","download03","download04","download05"])
         for (i in dirs){
             if(Directory.exists(i))
             {
                  Directory.delete(i,recursive:true)
             }
         }
    }
    @TestCase
    func testEnqueues01(): Unit {
        var url:String = "http://imgsrc.baidu.com/forum/w%3D580/sign=eed1753686d6277fe9123230183a1f63/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"
        let dir01=Directory.create("download01",recursive:true)
        let dir02=Directory.create("download02",recursive:true)
        let dir03=Directory.create("download03",recursive:true)
        let dir04=Directory.create("download04",recursive:true)
        let dir05=Directory.create("download05",recursive:true)
        let task01:DownloadTask = DownloadTaskBuilder(url,dir01).build()
        let task02:DownloadTask = DownloadTaskBuilder(url,dir02).build()
        let task03:DownloadTask = DownloadTaskBuilder(url,dir03).build()
        let task04:DownloadTask = DownloadTaskBuilder(url,dir04).build()
        let task05:DownloadTask = DownloadTaskBuilder(url,dir05).build()

        let tasks=Array<DownloadTask>([task01,task02,task03,task04,task05])
        DownloadTask.enqueues(tasks,MyListen())

        sleep(60*1000*1000*1000)
        @Assert(File.exists("download01/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"),true)
        @Assert(FileInfo("download01/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg").length,38662)

        @Assert(File.exists("download02/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"),true)
        @Assert(FileInfo("download02/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg").length,38662)

        @Assert(File.exists("download03/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"),true)
        @Assert(FileInfo("download03/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg").length,38662)

        @Assert(File.exists("download04/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"),true)
        @Assert(FileInfo("download04/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg").length,38662)

        @Assert(File.exists("download05/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg"),true)
        @Assert(FileInfo("download05/9dcd7cd98d1001e950d1f582b90e7bec55e7974b.jpg").length,38662)
    }


    @TestCase
    func testEnqueues03(): Unit {
        let tasks=Array<DownloadTask>()
        DownloadTask.enqueues(tasks,MyListen())
    }
}
