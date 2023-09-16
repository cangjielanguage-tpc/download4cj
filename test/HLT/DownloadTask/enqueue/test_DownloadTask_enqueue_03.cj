// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../../common.cj
@Test
public class TestDownloadTaskV003{
    //(已下载完成)暂停后继续下载
    @TestCase
    func testEnqueue03(): Unit {
        var url:String = small_file_url
        var fileName=small_file_name
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        @Assert(dir.fileList().size,0)
        var listen=MyListen()
        task.enqueue(listen)
        //动态判断执行状态
         var endFlag=true//进入循环的标志1
         var count=0 //进入循环标志2,,最长等待5分钟
         while(endFlag==true && count<timeOut){
             count+=1
             sleep(Duration.second)
             if(listen.flag11!=1 || File.exists(dirName+"/"+fileName)==false || FileInfo(dirName+"/"+fileName).length !=small_file_size){
                 endFlag=true
             }else{//文件存在
                 endFlag=false
             }
         }
        @Assert(dir.fileList().size,1)
        task.cancel()
        task.enqueue(listen)
        @Assert(listen.flag11,1)
        @Assert(listen.flag05,0)
    }
}
