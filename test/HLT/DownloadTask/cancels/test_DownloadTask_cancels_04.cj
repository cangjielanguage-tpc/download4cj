// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../../common.cj
@Test
public class TestDownloadTaskV003{
    //下载完成后暂停(全部暂停),task是同步执行，部分是异步执行
    @TestCase
    func testCancels04(): Unit {
        var url:String = small_file_url
        var fileName=small_file_name
        var dirName01="download_"+DateTime.now().nanosecond.toString()
        let dir01=Directory.create(dirName01,recursive:true)
        var dirName02="download_"+DateTime.now().nanosecond.toString()
        let dir02=Directory.create(dirName02,recursive:true)
        var dirName03="download_"+DateTime.now().nanosecond.toString()
        let dir03=Directory.create(dirName03,recursive:true)
        var dirName04="download_"+DateTime.now().nanosecond.toString()
        let dir04=Directory.create(dirName04,recursive:true)
        let task01:DownloadTask = DownloadTaskBuilder(url,dir01).build()
        let task02:DownloadTask = DownloadTaskBuilder(url,dir02).build()
        let task03:DownloadTask = DownloadTaskBuilder(url,dir03).build()
        let task04:DownloadTask = DownloadTaskBuilder(url,dir04).build()
        spawn{
            task01.execute(MyListen())
        }
        var listen01=MyListen()
        DownloadTask.enqueues(Array<DownloadTask>([task02,task03]),listen01)
        var listen02=MyListen()
        task04.enqueue(listen02)
        var endFlag=true//进入循环的标志1
        var count=0 //进入循环标志2,,最长等待5分钟
        while(endFlag==true && count<timeOut){
            count+=1
            sleep(Duration.second)
            if( File.exists(dirName01+"/"+fileName) ==false || File.exists(dirName02+"/"+fileName) ==false || File.exists(dirName03+"/"+fileName) ==false || File.exists(dirName04+"/"+fileName) ==false){
                endFlag=true
            }else if(  FileInfo(dirName01+"/"+fileName).length!=small_file_size || FileInfo(dirName02+"/"+fileName).length!=small_file_size || FileInfo(dirName03+"/"+fileName).length!=small_file_size || FileInfo(dirName04+"/"+fileName).length!=small_file_size){
                endFlag=true
            }else{//文件存在
                endFlag=false
            }
        }
        DownloadTask.cancels(Array<DownloadTask>([task01,task02,task03,task04]))
        @Assert(listen01.flag11,1)
        @Assert(listen01.flag05,0)
        @Assert(listen02.flag11,1)
        @Assert(listen02.flag05,0)
        sleep(100*Duration.second)
        var length_fileInfo01_ns=FileInfo(dirName01+"/"+fileName).length
        var length_fileInfo02_ns=FileInfo(dirName02+"/"+fileName).length
        var length_fileInfo03_ns=FileInfo(dirName03+"/"+fileName).length
        var length_fileInfo04_ns=FileInfo(dirName04+"/"+fileName).length
        @Assert(length_fileInfo01_ns,small_file_size)
        @Assert(length_fileInfo02_ns,small_file_size)
        @Assert(length_fileInfo03_ns,small_file_size)
        @Assert(length_fileInfo04_ns,small_file_size)
    }
}
