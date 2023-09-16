// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../../common.cj
@Test
public class TestBlockInfoV003{
    //下载暂停获取BlockInfo，异步静态函数
    @TestCase
    func testGetCurrentOffset03(): Unit {
        var url:String = big_file_url
        var fileName=big_file_name
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        DownloadTask.enqueues(Array<DownloadTask>([task]),MyListen())
         var endFlag=true//进入循环的标志1
         var count=0 //进入循环标志2,,最长等待5分钟
         while(endFlag==true && count<timeOut){
             count+=1
             sleep(Duration.second)
             if(File.exists(dirName+"/"+fileName) ){
                 endFlag=true
             }else{//文件存在
                 endFlag=false
             }
         }
        DownloadTask.cancels(Array<DownloadTask>([task]))
        var blocks01=task.getBlockInfoList().getOrThrow()
        var currentOffset_1st=ArrayList<Int64>()
        for (i in blocks01){
             currentOffset_1st.append(i.getCurrentOffset())
        }
        sleep(Duration.second)
        var blocks02=task.getBlockInfoList().getOrThrow()
        var currentOffset_2nd=ArrayList<Int64>()
        for (i in blocks02){
             currentOffset_2nd.append(i.getCurrentOffset())
        }
        for (i in 0..blocks01.size){
            @Assert(currentOffset_1st[i],currentOffset_2nd[i])
        }
    }
}
