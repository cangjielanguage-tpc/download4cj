// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../common.cj
@Test
public class Test01{
    @TestCase
    func testuse01(): Unit {
        var url:String = "https://nodejs.org/dist"
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        var flag=1
        try{
            task.execute(MyListen())
        }catch(e:Exception){
            flag=0
        }
        @Assert(flag,1)
    }
}
