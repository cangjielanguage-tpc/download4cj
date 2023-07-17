// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/cryptocj
// dependence: ../common.cj
@Test
public class Test01{
    @TestCase
    func testgetFilename01(): Unit {
        var url:String = big_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let filename="target"
        let task:DownloadTask = DownloadTaskBuilder(url,dir).setFilename(filename).build()
        var taskFilename=task.getFilename().getOrThrow()
        @Assert(taskFilename,filename)
    }
    @TestCase
    func testgetFilename02(): Unit {
        var url:String = big_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        var filename=big_file_name
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        task.enqueue(MyListen())
        while(File.exists(dirName+"/"+filename) == false){
            sleep(1*Duration.second)
        }
        var taskFilename=task.getFilename().getOrThrow()
        @Assert(taskFilename,filename)
    }
}
