// 3rd_party_lib:download4cj/build/okdownload:download4cj/build/okhttp:download4cj/build/cryptocj
// dependence: ../common.cj
@Test
public class Test01{
    @TestCase
    func testsetFilename01(): Unit {
        var url:String = big_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let filename="target.tar.gz"
        let task:DownloadTask = DownloadTaskBuilder(url,dir).setFilename(filename).build()
        task.enqueue(MyListen())
        while(File.exists(dirName+"/"+filename) == false){
            sleep(1*Duration.second)
        }
        @Assert(File.exists(dirName+"/"+filename),true)
    }
    @TestCase
    func testsetFilename02(): Unit {
        var url:String = big_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let filename="target.gz"
        let task:DownloadTask = DownloadTaskBuilder(url,dir).setFilename(filename).build()
        task.enqueue(MyListen())
        while(File.exists(dirName+"/"+filename) == false){
            sleep(1*Duration.second)
        }
        @Assert(File.exists(dirName+"/"+filename),true)
    }
    @TestCase
    func testsetFilename03(): Unit {
        var url:String = big_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let filename="target.tar"
        let task:DownloadTask = DownloadTaskBuilder(url,dir).setFilename(filename).build()
        task.enqueue(MyListen())
        while(File.exists(dirName+"/"+filename) == false){
            sleep(1*Duration.second)
        }
        @Assert(File.exists(dirName+"/"+filename),true)
    }
    @TestCase
    func testsetFilename04(): Unit {
        var url:String = big_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let filename="target"
        let task:DownloadTask = DownloadTaskBuilder(url,dir).setFilename(filename).build()
        task.enqueue(MyListen())
        while(File.exists(dirName+"/"+filename) == false){
            sleep(1*Duration.second)
        }
        @Assert(File.exists(dirName+"/"+filename),true)
    }
}
