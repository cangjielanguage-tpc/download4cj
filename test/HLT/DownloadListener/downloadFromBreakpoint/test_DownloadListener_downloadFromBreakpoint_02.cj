// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../../common.cj
@Test
public class TestDownloadListenerV003{
    //下载暂停后继续下载，异步静态函数

    @TestCase
    func testDownloadFromBreakpoint02(): Unit {
        var url:String = big_file_url
        var fileName=big_file_name
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        var listen=MyListen()
        DownloadTask.enqueues(Array<DownloadTask>([task]),listen)
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
        DownloadTask.cancels(Array<DownloadTask>([task]))
        var length_fileInfo=FileInfo(dirName+"/"+fileName).length
        @Assert(listen.flag05,0)
        DownloadTask.enqueues(Array<DownloadTask>([task]),listen)
        var length_fileInfo_continue=FileInfo(dirName+"/"+fileName).length
        count=0
        endFlag=true
         while(endFlag==true && count<timeOut){
             count+=1
             sleep(Duration.second)
             length_fileInfo_continue=FileInfo(dirName+"/"+fileName).length
             if(length_fileInfo_continue<=length_fileInfo&&length_fileInfo_continue!=big_file_size){
                 endFlag=true
             }else{//文件存在
                 endFlag=false
             }
         }
        @Assert(listen.flag05,1)
    }
}
