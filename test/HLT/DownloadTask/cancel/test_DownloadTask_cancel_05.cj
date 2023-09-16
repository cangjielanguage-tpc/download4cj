// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../../common.cj
@Test
public class TestDownloadTaskV003{
    //异步下载，任务下载完成后暂停（即调用enqueue），调用cancel暂停
    @TestCase
    func testCancel05(): Unit {
        var url:String = small_file_url
        var fileName=small_file_name
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        task.enqueue(MyListen())
         var endFlag=true//进入循环的标志1
         var count=0 //进入循环标志2,,最长等待5分钟
         while(endFlag==true && count<timeOut){
             count+=1
             sleep(Duration.second)
             if(File.exists(dirName+"/"+fileName) == false ){
                 endFlag=true
             }else{//文件存在
                 endFlag=false
             }
         }
        var length_fileInfo=FileInfo(dirName+"/"+fileName).length
         while(endFlag==true && count<timeOut){
             count+=1
             sleep(Duration.second)
             length_fileInfo=FileInfo(dirName+"/"+fileName).length
             if(length_fileInfo!=small_file_size){
                 endFlag=true
             }else{//文件存在
                 endFlag=false
             }
         }
        task.cancel()
        length_fileInfo=FileInfo(dirName+"/"+fileName).length
        @Assert(length_fileInfo == small_file_size,true)
    }
}
