// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../../common.cj
@Test
public class TestDownloadListenerV003{
    //下载结束，同步
    @TestCase
    func testDownloadFromBreakpoint03(): Unit {
        var url:String = big_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        var listen=MyListen()
        task.execute(listen)
        @Assert(listen.flag05,0)
    }
}
