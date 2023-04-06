// 3rd_party_lib:ok-download/build/okdownload:ok-download/build/okhttp:ok-download/build/cryptocj
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
    func testEnqueues02(): Unit {
        var url:String = "http://imgsrc.baidu.com/forum/w%3D580"
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

        sleep(20*1000*1000*1000)
        @Assert(File.exists("download01/w%3D580"),true)
        @Assert(FileInfo("download01/w%3D580").length,0)

        @Assert(File.exists("download02/w%3D580"),true)
        @Assert(FileInfo("download02/w%3D580").length,0)

        @Assert(File.exists("download03/w%3D580"),true)
        @Assert(FileInfo("download03/w%3D580").length,0)

        @Assert(File.exists("download04/w%3D580"),true)
        @Assert(FileInfo("download04/w%3D580").length,0)

        @Assert(File.exists("download05/w%3D580"),true)
        @Assert(FileInfo("download05/w%3D580").length,0)
    }

}
