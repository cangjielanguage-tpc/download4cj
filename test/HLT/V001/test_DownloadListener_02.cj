// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../common.cj
@Test
public class Test01{
    @TestCase
    public func testMyListen01(): Unit {
        var url:String = small_file_url
        var fileName=small_file_name
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        let listener01=MyListen()
        task.enqueue(listener01)
        var endFlag=true//进入循环的标志1
        var count=0 //进入循环标志2,,最长等待5分钟
        while(endFlag==true && count<timeOut){//下载目标达到，或者等待时间超多10min,退出循环
            count+=1
            sleep(Duration.second)
            if(File.exists(dirName+"/"+fileName)  == false || FileInfo(dirName+"/"+fileName).length<small_file_size){//文件不存在继续循环
                endFlag=true
            }else{//文件存在
                endFlag=false
            }
        }
        @Assert(listener01.flag01,1)
        @Assert(listener01.flag02,1)
        @Assert(listener01.flag03,1)
        @Assert(listener01.flag04,1)
        @Assert(listener01.flag05,0)
        @Assert(listener01.flag06,1)
        @Assert(listener01.flag07,1)
        @Assert(listener01.flag08,1)
        @Assert(listener01.flag09,1)
        @Assert(listener01.flag10,1)
        @Assert(listener01.flag11,1)
    }
}
