// 3rd_party_lib:download4cj/build/okdownload:download4cj/build/okhttp:download4cj/build/cryptocj
// dependence: ../common.cj
@Test
public class Test02{
    @TestCase
    func testEnqueues02(): Unit {
        var url:String = "http://imgsrc.baidu.com/forum/w%3D580"
        var fileName="w%3D580"
        var dirName01="download_"+DateTime.now().nanosecond.toString()
        let dir01=Directory.create(dirName01,recursive:true)
        var dirName02="download_"+DateTime.now().nanosecond.toString()
        let dir02=Directory.create(dirName02,recursive:true)
        var dirName03="download_"+DateTime.now().nanosecond.toString()
        let dir03=Directory.create(dirName03,recursive:true)
        var dirName04="download_"+DateTime.now().nanosecond.toString()
        let dir04=Directory.create(dirName04,recursive:true)
        var dirName05="download_"+DateTime.now().nanosecond.toString()
        let dir05=Directory.create(dirName05,recursive:true)
        let task01:DownloadTask = DownloadTaskBuilder(url,dir01).build()
        let task02:DownloadTask = DownloadTaskBuilder(url,dir02).build()
        let task03:DownloadTask = DownloadTaskBuilder(url,dir03).build()
        let task04:DownloadTask = DownloadTaskBuilder(url,dir04).build()
        let task05:DownloadTask = DownloadTaskBuilder(url,dir05).build()
        let tasks=Array<DownloadTask>([task01,task02,task03,task04,task05])
        var listen=MyListen()
        DownloadTask.enqueues(tasks,listen)
        while(File.exists(dirName01+"/"+fileName) == false ||
              File.exists(dirName02+"/"+fileName) == false ||
              File.exists(dirName03+"/"+fileName) == false ||
              File.exists(dirName04+"/"+fileName) == false ||
              File.exists(dirName05+"/"+fileName) == false ){
            sleep(1*Duration.second)
        }
        @Assert(FileInfo(dirName01+"/"+fileName).length,0)
        @Assert(FileInfo(dirName02+"/"+fileName).length,0)
        @Assert(FileInfo(dirName03+"/"+fileName).length,0)
        @Assert(FileInfo(dirName04+"/"+fileName).length,0)
        @Assert(FileInfo(dirName05+"/"+fileName).length,0)
    }
}
