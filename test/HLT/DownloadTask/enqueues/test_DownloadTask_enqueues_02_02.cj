// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../../common.cj
@Test
public class TestDownloadTaskV003{
    //暂停后继续下载,全部任务继续下载，异步和异步
    @TestCase
    func testEnqueues0202(): Unit {
        var url:String = big_file_url2
        var fileName=big_file_name2
        //task03
        var dirName03="download_"+DateTime.now().nanosecond.toString()
        let dir03=Directory.create(dirName03,recursive:true)
        let task03:DownloadTask = DownloadTaskBuilder(url,dir03).build()
        var listen03=MyListen()

        //tast04
        var dirName04="download_"+DateTime.now().nanosecond.toString()
        let dir04=Directory.create(dirName04,recursive:true)
        let task04:DownloadTask = DownloadTaskBuilder(url,dir04).build()
        var listen04=MyListen()
        //异步执行
        DownloadTask.enqueues(Array<DownloadTask>([task03]),listen03)
        task04.enqueue(listen04)
        //动态判断执行状态
        var endFlag=true//进入循环的标志1
        var count=0 //进入循环标志2,,最长等待5分钟
        while(endFlag==true && count<timeOut){
            count+=1
            sleep(Duration.second)
            if(File.exists(dirName03+"/"+fileName) ==false || File.exists(dirName04+"/"+fileName) ==false){
                endFlag=true
            }else{//文件存在
                endFlag=false
            }
        }
        //批量暂停
        DownloadTask.cancels(Array<DownloadTask>([task03,task04]))
        //异步执行
        DownloadTask.enqueues(Array<DownloadTask>([task03]),listen03)
        task04.enqueue(listen04)
        //当前下载结果，通过下载文件内容
        var length_fileInfo03_ns=FileInfo(dirName03+"/"+fileName).length
        var length_fileInfo04_ns=FileInfo(dirName04+"/"+fileName).length
        //动态判断文件是否下载完成，暂停后继续下载,完成文件下载
        endFlag=true//进入循环的标志1
        count=0 //进入循环标志2,,最长等待5分钟
        while(endFlag==true && count<timeOut){
            count+=1
            sleep(Duration.second)
            length_fileInfo03_ns=FileInfo(dirName03+"/"+fileName).length
            length_fileInfo04_ns=FileInfo(dirName04+"/"+fileName).length
            if(listen03.flag11!=1){//
                endFlag=true
            }else if(length_fileInfo03_ns !=big_file_size2){
                endFlag=true
            }else if(listen04.flag11!=1){
                endFlag=true
            }else if(length_fileInfo04_ns !=big_file_size2){
                endFlag=true
            }else{//文件存在
                endFlag=false
            }
        }
        @Assert(length_fileInfo03_ns,big_file_size2)
        @Assert(length_fileInfo04_ns,big_file_size2)
    }
}
