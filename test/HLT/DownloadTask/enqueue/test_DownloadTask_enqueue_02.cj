// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../../common.cj
@Test
public class TestDownloadTaskV003{
    //(未下载完成)暂停后继续下载
    @TestCase
    func testEnqueue02(): Unit {
        var url:String = big_file_url
        var fileName=big_file_name
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)

        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        var listen=MyListen()
        task.enqueue(listen)
        //动态判断执行状态
         var endFlag=true//进入循环的标志1
         var count=0 //进入循环标志2,,最长等待5分钟
         while(endFlag==true && count<timeOut){
             count+=1
             sleep(Duration.second)
             if(File.exists(dirName+"/"+fileName)==false){
                 endFlag=true
             }else{//文件存在
                 endFlag=false
             }
         }
        task.cancel()
        var length_fileInfo=FileInfo(dirName+"/"+fileName).length
        @Assert(length_fileInfo<=big_file_size,true)
        task.enqueue(listen)
        var length_fileInfo_ns=FileInfo(dirName+"/"+fileName).length
         endFlag=true//进入循环的标志1
         count=0 //进入循环标志2,,最长等待5分钟
         while(endFlag==true && count<timeOut){
             count+=1
             sleep(Duration.second)
             length_fileInfo_ns=FileInfo(dirName+"/"+fileName).length
             if(listen.flag11!=1 || length_fileInfo_ns <big_file_size){
                 endFlag=true
             }else{//文件存在
                 endFlag=false
             }
         }
        @Assert(length_fileInfo_ns,big_file_size)
    }
}
