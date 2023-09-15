// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../../common.cj
@Test
public class TestBlockInfoV003{
    //任务未开始执行获取
    @TestCase
    func testGetCurrentOffset(): Unit {
        var url:String = big_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
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
