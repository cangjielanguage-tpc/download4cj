// 3rd_party_lib:download4cj/build/download4cj:download4cj/build/httpclient4cj:download4cj/build/crypto4cj
// dependence: ../../common.cj
@Test
public class TestBlockInfoV003{
    //下载暂停获取BlockInfo，异步静态函数
    @TestCase
    func testGetRangeLeft03(): Unit {
        var url:String = big_file_url
        var dirName="download_"+DateTime.now().nanosecond.toString()
        let dir=Directory.create(dirName,recursive:true)
        let task:DownloadTask = DownloadTaskBuilder(url,dir).build()
        DownloadTask.enqueues(Array<DownloadTask>([task]),MyListen())
         var endFlag=true//进入循环的标志1
         var count=0 //进入循环标志2,,最长等待5分钟
         while(endFlag==true && count<timeOut){
             count+=1
             sleep(Duration.second)
             if(File.exists(dirName+"/"+big_file_name) ==false  ){
                 endFlag=true
             }else{//文件存在
                 endFlag=false
             }
         }
        DownloadTask.cancels(Array<DownloadTask>([task]))
        var blocks01=task.getBlockInfoList().getOrThrow()
        var rangeLeft_1st=ArrayList<Int64>()
        var currentOffset_1st=ArrayList<Int64>()
        var startOffset_1st=ArrayList<Int64>()
        for (i in blocks01){
             rangeLeft_1st.append(i.getRangeLeft())
             startOffset_1st.append(i.getStartOffset())
             currentOffset_1st.append(i.getCurrentOffset())
        }
        sleep(5*Duration.second)
        var blocks02=task.getBlockInfoList().getOrThrow()
        var rangeLeft_2nd=ArrayList<Int64>()
        var currentOffset_2nd=ArrayList<Int64>()
        var startOffset_2nd=ArrayList<Int64>()
        for (i in blocks02){
             rangeLeft_2nd.append(i.getRangeLeft())
             startOffset_2nd.append(i.getStartOffset())
             currentOffset_2nd.append(i.getCurrentOffset())
        }
        for (i in 0..blocks01.size){
            @Assert(rangeLeft_1st[i],rangeLeft_2nd[i])
            @Assert(rangeLeft_1st[i],startOffset_1st[i]+currentOffset_1st[i])
            @Assert(rangeLeft_2nd[i],startOffset_2nd[i]+currentOffset_2nd[i])
        }
    }
}
