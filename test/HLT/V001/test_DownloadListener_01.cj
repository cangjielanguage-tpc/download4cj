// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../common.cj
@Test
public class Test01{
    @TestCase
    public func testMyListen01(): Unit {
        var url:String = small_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        let listener01=MyListen()
        task.execute(listener01)
        @Assert(listener01.flag01,1)
        @Assert(listener01.flag02,1)
        @Assert(listener01.flag03,1)
        @Assert(listener01.flag04,1)
        @Assert(listener01.flag05,0)
        @Assert(listener01.flag06,1)
        @Assert(listener01.flag07,1)
        @Assert(listener01.flag08,1)
        @Assert(listener01.flag09,1)
        @Assert(listener01.flag10,1)
        @Assert(listener01.flag11,1)
    }
}
