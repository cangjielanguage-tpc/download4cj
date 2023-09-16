// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../../common.cj
@Test
public class TestDownloadTaskV003{
    //任务未执行（即调用execute或者调用enqueue或者作为enqueues入参），调用cancel暂停
    @TestCase
    func testCancel01(): Unit {
        var url:String = big_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)

        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        task.cancel()
        @Assert(dir.isEmpty(),true)
    }
}
