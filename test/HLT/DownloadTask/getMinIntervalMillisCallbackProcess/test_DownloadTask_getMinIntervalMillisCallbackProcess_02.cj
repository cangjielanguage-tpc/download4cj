// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../../common.cj
@Test
public class TestDownloadTaskV003{
    //不设置的展示默认值
    @TestCase
    func testGetMinIntervalMillisCallbackProcess02(): Unit {
        var url:String = big_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        var dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        @Assert(task.getMinIntervalMillisCallbackProcess(),3000)
    }
}
