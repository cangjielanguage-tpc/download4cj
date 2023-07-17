// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/cryptocj
// dependence: ../common.cj
@Test
public class Test01{
    @TestCase
    func testgetConnectionCount01(): Unit {
        var url:String = big_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        task.execute(MyListen())
        @Assert(task.getConnectionCount()!=0,true)
    }
    @TestCase
    func testgetConnectionCount02(): Unit {
        var url:String = small_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        task.enqueue(MyListen())
        while(File.exists(dirName+"/"+small_file_name) == false){
            sleep(1*Duration.second)
        }
        @Assert(task.getConnectionCount()!=0,true)
    }
}
