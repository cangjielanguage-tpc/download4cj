// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../common.cj
@Test
public class Test01{
    @TestCase
    func testgetReadBufferSize01(): Unit {
        var url:String = big_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        var readBufferSize=task.getReadBufferSize()
        @Assert(readBufferSize,4*1024)
    }
    @TestCase
    func testgetReadBufferSize02(): Unit {
        var url:String = big_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).setReadBufferSize(Int64.Max).build()
        var readBufferSize=task.getReadBufferSize()
        @Assert(readBufferSize,Int64.Max)
    }
    @TestCase
    func testgetReadBufferSize03(): Unit {
        var url:String = big_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        var flag=1
        try{
            DownloadTaskBuilder(url,dir).setReadBufferSize(0).build()
        }catch(e:IllegalArgumentException){
            flag=0
        }
        @Assert(flag,0)
    }
    @TestCase
    func testgetReadBufferSize04(): Unit {
        var url:String = big_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        var flag=1
        try{
            DownloadTaskBuilder(url,dir).setReadBufferSize(Int64.Min).build()
        }catch(e:IllegalArgumentException){
            flag=0
        }
        @Assert(flag,0)
    }
}
