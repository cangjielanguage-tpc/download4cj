// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../../common.cj
@Test
public class TestDownloadTaskV003{
    //同步下载，任务下载完成后暂停（即调用execute），调用cancel暂停
    @TestCase
    func testCancel03(): Unit {
        var url:String = small_file_url
        var fileName=small_file_name
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)

        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        var listen=MyListen()
        task.execute(listen)
        var length_fileInfo=FileInfo(dirName+"/"+fileName).length
        @Assert(length_fileInfo,small_file_size)
        task.cancel()
        length_fileInfo=FileInfo(dirName+"/"+fileName).length
        @Assert(length_fileInfo,small_file_size)
        @Assert(listen.flag11,1)
    }
}
