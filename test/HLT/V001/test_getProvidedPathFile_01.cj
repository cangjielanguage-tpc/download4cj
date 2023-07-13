// 3rd_party_lib:download4cj/build/okdownload:download4cj/build/okhttp:download4cj/build/cryptocj
// dependence: ../common.cj
@Test
public class Test01{
    @TestCase
    func testgetProvidedPathFile01(): Unit {
        var url:String = small_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        task.execute(MyListen())
        var length=task.getProvidedPathFile().getOrThrow().info.length
        var path01=task.getProvidedPathFile().getOrThrow().info.path.fileName.getOrThrow()
        @Assert(length,small_file_size)
        @Assert(path01,small_file_name)
    }
}
