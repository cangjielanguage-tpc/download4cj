// 3rd_party_lib:download4cj/build/okdownload:download4cj/build/okhttp:download4cj/build/cryptocj
// dependence: ../common.cj
@Test
public class Test01{
    @TestCase
    func testgetId01(): Unit {
        var url:String = big_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        var taskid=task.getId()
        @Assert(taskid is Int64,true)
    }
}
