// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../../common.cj
@Test
public class TestDownloadTaskV003{
    //暂停后继续下载
    @TestCase
    func testExecute02(): Unit {
        var url:String = big_file_url
        var fileName=big_file_name
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)

        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        var listen=MyListen()
        spawn{
            task.execute(MyListen())
        }
        var endFlag=true//进入循环的标志1
        var count=0 //进入循环标志2,,最长等待5分钟
        while(endFlag==true && count<timeOut){//下载目标达到，或者等待时间超多10min,退出循环
            count+=1
            sleep(Duration.second)
            if(File.exists(dirName+"/"+fileName)==false){//文件不存在继续循环
                endFlag=true
            }else{//文件存在
                endFlag=false
            }
        }
        task.cancel()
        task.execute(listen)
        var length_fileInfo_ns=FileInfo(dirName+"/"+fileName).length
        endFlag=true//进入循环的标志1
        count=0 //进入循环标志2,,最长等待5分钟
        while(endFlag==true && count<timeOut){//下载目标达到，或者等待时间超多10min,退出循环
            count+=1
            sleep(Duration.second)
            length_fileInfo_ns=FileInfo(dirName+"/"+fileName).length
            if(length_fileInfo_ns < big_file_size){//文件不存在继续循环
                endFlag=true
            }else{//文件存在
                endFlag=false
            }
        }
        @Assert(length_fileInfo_ns,big_file_size)
    }
}
