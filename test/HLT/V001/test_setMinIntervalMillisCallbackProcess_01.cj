// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../common.cj
@Test
public class Test01{
    @TestCase
    func testsetMinIntervalMillisCallbackProcess01(): Unit {
        var url:String = small_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).setMinIntervalMillisCallbackProcess(30).build()
        task.execute(MyListen())
    }
    @TestCase
    func testsetMinIntervalMillisCallbackProcess02(): Unit {
        var url:String = small_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).setMinIntervalMillisCallbackProcess(Int64.Max).build()
        task.execute(MyListen())
    }
    @TestCase
    func testsetMinIntervalMillisCallbackProcess03(): Unit {
        var url:String = small_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        var flag=1
        try{
            DownloadTaskBuilder(url,dir).setMinIntervalMillisCallbackProcess(Int64.Min).build()
        }catch(e:IllegalArgumentException){
            flag=0
        }
        @Assert(flag,0)
    }
    @TestCase
    func testsetMinIntervalMillisCallbackProcess04(): Unit {
        var url:String = small_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).setMinIntervalMillisCallbackProcess(0).build()
        task.execute(MyListen())
    }
    @TestCase
    func testsetMinIntervalMillisCallbackProcess05(): Unit {
        var url:String = small_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        task.execute(MyListen())
    }
}
