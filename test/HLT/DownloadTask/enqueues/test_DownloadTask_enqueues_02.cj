// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../../common.cj
@Test
public class TestDownloadTaskV003{
    //暂停后继续下载,部分任务继续下载,同步和异步
    @TestCase
    func testEnqueues02(): Unit {
        var url:String = big_file_url2
        var fileName=big_file_name2
        var dirName01="download_"+DateTime.now().nanosecond.toString()
        let dir01=Directory.create(dirName01,recursive:true)
        var dirName02="download_"+DateTime.now().nanosecond.toString()
        let dir02=Directory.create(dirName02,recursive:true)


        let task01:DownloadTask = DownloadTaskBuilder(url,dir01).build()
        let task02:DownloadTask = DownloadTaskBuilder(url,dir02).build()
        var listen02=MyListen()
        spawn{
            task01.execute(MyListen())
        }
        DownloadTask.enqueues(Array<DownloadTask>([task02]),listen02)
         //动态判断执行状态
         var endFlag=true//进入循环的标志1
         var count=0 //进入循环标志2,,最长等待5分钟
         while(endFlag==true && count<timeOut){
             count+=1
             sleep(Duration.second)
             if(File.exists(dirName01+"/"+fileName) ==false){
                 endFlag=true
             }else if(File.exists(dirName02+"/"+fileName) ==false){
                 endFlag=true
             }else{//文件存在
                 endFlag=false
             }
         }
        DownloadTask.cancels(Array<DownloadTask>([task01,task02]))
        spawn{
            task01.execute(MyListen())
        }
        DownloadTask.enqueues(Array<DownloadTask>([task02]),listen02)
        var length_fileInfo01_ns=FileInfo(dirName01+"/"+fileName).length
        var length_fileInfo02_ns=FileInfo(dirName02+"/"+fileName).length
        endFlag=true//进入循环的标志1
        count=0 //进入循环标志2,,最长等待5分钟
        while(endFlag==true && count<timeOut){
            count+=1
            sleep(Duration.second)
            length_fileInfo01_ns=FileInfo(dirName01+"/"+fileName).length
            length_fileInfo02_ns=FileInfo(dirName02+"/"+fileName).length
            if(listen02.flag11!=1 || length_fileInfo01_ns !=big_file_size2 || length_fileInfo02_ns !=big_file_size2 ){
                endFlag=true
            }else{//文件存在
                endFlag=false
            }
        }
        @Assert(length_fileInfo01_ns,big_file_size2)
        @Assert(length_fileInfo02_ns,big_file_size2)
    }
}
