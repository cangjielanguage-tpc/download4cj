package okdownload

public class FetchDataInterceptor <: InterceptorFetch {

    private let inputStream:InputStream


    private let readBuffer:Array<Byte>
    private let outputStream:MultiPointOutputStream
    private let blockIndex:Int64
    private let task:DownloadTask
    private let dispatcher:CallbackDispatcher


    public init(blockIndex:Int64,inputStream:InputStream,outputStream:MultiPointOutputStream,task:DownloadTask){
        this.blockIndex = blockIndex
        this.inputStream = inputStream
        this.readBuffer = Array<Byte>(task.getReadBufferSize(),{i => 0})
        this.outputStream = outputStream
        this.task = task
        this.dispatcher = OkDownload.withs().callbackDispatcher()
    }


    public func interceptFetch(chain:DownloadChain):Int64{
        if (chain.getCache().isInterrupt()){
            throw InterruptException.SIGNAL
        }

        // fetch

        var fetchLength:Int64 = inputStream.read(readBuffer)

        //var fetchLength:Int64 = 0

        // let logger: SimpleLogger = SimpleLogger()
        // var s = File("./stdout1.log", OpenOption.CreateOrAppend)
        // logger.setOutput(s)
        // logger.log(LogLevel.OFF, "在读文件fetchLength="+fetchLength.toString())


        if(fetchLength == 0){
            return fetchLength
        }


        if(fetchLength<task.getReadBufferSize()){
            outputStream.write(blockIndex, readBuffer.slice(0,fetchLength), fetchLength)
        }else{
            outputStream.write(blockIndex, readBuffer, fetchLength)
        }



         //outputStream.write(blockIndex, readBuffer, fetchLength)


        // if (fetchLength < -1) {
        //     return fetchLength
        // }

        // write to file


        // let logger2: SimpleLogger = SimpleLogger()
        // var s2 = File("./stdout2.log", OpenOption.CreateOrAppend)
        // logger2.setOutput(s2)
        // logger2.log(LogLevel.OFF, "在写文件write write")

        chain.increaseCallbackBytes(fetchLength)

        if (this.dispatcher.isFetchProcessMoment(task)) {
            //println("进来了啊啊啊啊")
            chain.flushNoCallbackIncreaseBytes()
        }

        return fetchLength

    }


}
