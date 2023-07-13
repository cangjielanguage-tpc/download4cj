// 3rd_party_lib:download4cj/build/okdownload:download4cj/build/okhttp:download4cj/build/cryptocj
// dependence: ../common.cj
@Test
public class Test01{
    public override func beforeEach(): Unit {
		 if(Directory.exists("download"))
		 {
			  Directory.delete("download",recursive:true)
		 }
    }
    @TestCase
    func testgetFlushBufferSize01(): Unit {
        var url:String = big_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        var flushBufferSize=task.getFlushBufferSize()
        @Assert(flushBufferSize,16*1024)
    }
    @TestCase
    func testgetFlushBufferSize02(): Unit {
        var url:String = big_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).setFlushBufferSize(Int64.Max).build()
        var flushBufferSize=task.getFlushBufferSize()
        @Assert(flushBufferSize,Int64.Max)
    }
    @TestCase
    func testgetFlushBufferSize03(): Unit {
        var url:String = big_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        var flag=1
        try{
            DownloadTaskBuilder(url,dir).setFlushBufferSize(0).build()
        }catch(e:IllegalArgumentException){
            flag=0
        }
        @Assert(flag,0)
    }
    @TestCase
    func testgetFlushBufferSize04(): Unit {
        var url:String = big_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        var flag=1
        try{
            DownloadTaskBuilder(url,dir).setFlushBufferSize(Int64.Min).build()
        }catch(e:IllegalArgumentException){
            flag=0
        }
        @Assert(flag,0)
    }
}
