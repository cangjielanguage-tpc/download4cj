// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../../common.cj
@Test
public class TestBlockInfoV003{
    //下载完成后获取BlockInfo，同步成员函数
    @TestCase
    func testGetContentLength02(): Unit {
        var url:String = small_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        spawn{
            task.execute(MyListen())
        }
         var endFlag=true//进入循环的标志1
         var count=0 //进入循环标志2,,最长等待5分钟
         while(endFlag==true && count<timeOut){
             count+=1
             sleep(Duration.second)
             if(File.exists(dirName+"/"+small_file_name) ==false || FileInfo(dirName+"/"+small_file_name).length!=small_file_size ){
                 endFlag=true
             }else{//文件存在
                 endFlag=false
             }
         }
        var blocks01=task.getBlockInfoList().getOrThrow()
        sleep(3*Duration.second)
        var blocks02=task.getBlockInfoList().getOrThrow()
        for (i in 0..blocks01.size){
            @Assert(blocks01[i].getContentLength(),blocks02[i].getContentLength())
        }
    }
}
