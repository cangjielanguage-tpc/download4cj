// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../../common.cj
@Test
public class TestDownloadTaskV003{
    //下载完成后暂停，再继续下载
    @TestCase
    func testExecute03(): Unit {
        var url:String = small_file_url
        var fileName=small_file_name
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)

        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        var listen01=MyListen()
        var listen02=MyListen()
        task.execute(listen01)
        var length_fileInfo=FileInfo(dirName+"/"+fileName).length
        var endFlag=true//进入循环的标志1
        var count=0 //进入循环标志2,,最长等待5分钟
        while(endFlag==true && count<timeOut){//下载目标达到，或者等待时间超多10min,退出循环
            count+=1
            sleep(Duration.millisecond)
            length_fileInfo=FileInfo(dirName+"/"+fileName).length
            if(File.exists(dirName+"/"+fileName)==false || length_fileInfo <small_file_size){//文件不存在继续循环
                endFlag=true
            }else{//文件存在且下载结束,终止循环等待
                endFlag=false
            }
        }
        task.cancel()
        task.execute(listen02)
        sleep(Duration.second*3)
        var length_fileInfo_ns=FileInfo(dirName+"/"+fileName).length
        @Assert(length_fileInfo_ns,small_file_size)
        @Assert(listen02.flag11,1)
    }
}
