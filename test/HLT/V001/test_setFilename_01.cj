// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
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
        var endFlag=true//进入循环的标志1
        var count=0 //进入循环标志2,,最长等待5分钟
        while(endFlag==true && count<timeOut){//下载目标达到，或者等待时间超多10min,退出循环
            count+=1
            sleep(Duration.second)
            if(File.exists(dirName+"/"+filename) == false){//文件不存在继续循环
                endFlag=true
            }else{//文件存在
                endFlag=false
            }
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
        var endFlag=true//进入循环的标志1
        var count=0 //进入循环标志2,,最长等待5分钟
        while(endFlag==true && count<timeOut){//下载目标达到，或者等待时间超多10min,退出循环
            count+=1
            sleep(Duration.second)
            if(File.exists(dirName+"/"+filename) == false){//文件不存在继续循环
                endFlag=true
            }else{//文件存在
                endFlag=false
            }
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
        var endFlag=true//进入循环的标志1
        var count=0 //进入循环标志2,,最长等待5分钟
        while(endFlag==true && count<timeOut){//下载目标达到，或者等待时间超多10min,退出循环
            count+=1
            sleep(Duration.second)
            if(File.exists(dirName+"/"+filename) == false){//文件不存在继续循环
                endFlag=true
            }else{//文件存在
                endFlag=false
            }
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
        var endFlag=true//进入循环的标志1
        var count=0 //进入循环标志2,,最长等待5分钟
        while(endFlag==true && count<timeOut){//下载目标达到，或者等待时间超多10min,退出循环
            count+=1
            sleep(Duration.second)
            if(File.exists(dirName+"/"+filename) == false){//文件不存在继续循环
                endFlag=true
            }else{//文件存在
                endFlag=false
            }
        }
        @Assert(File.exists(dirName+"/"+filename),true)
    }
}
