// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../../common.cj
@Test
public class TestDownloadTaskV003{
    //任务未执行（即调用execute或者调用enqueue或者作为enqueues入参），调用getBlockInfoList
    @TestCase
    func testGetBlockInfoList01(): Unit {
        var url:String = big_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        var dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        var flag=false
        try{
            task.getBlockInfoList().getOrThrow()
        }catch(e:NoneValueException){
            flag=true
        }
        @Assert(flag,true)
    }
}
