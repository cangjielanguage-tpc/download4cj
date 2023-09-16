// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../../common.cj
@Test
public class TestDownloadTaskV003{
    public override func beforeEach(): Unit {}
    //异步下载，下载完成后暂停（已调用enqueue，但未执行结束）,调用getBlockInfoList
    @TestCase
    func testGetBlockInfoList04(): Unit {
        var url:String = small_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        var dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        task.execute(MyListen())
        task.cancel()
        var blocks=task.getBlockInfoList().getOrThrow()
        var all=0
        for (i in blocks){
            all=i.getContentLength()+all
        }
        @Assert(all,small_file_size)
    }
}
