/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights resvered.
 */

package download4cj

public class FetchDataInterceptor <: InterceptorFetch {

    private let source:Source
    private let readBuffer:Array<Byte>
    private let outputStream:MultiPointOutputStream
    private let blockIndex:Int64
    private let task:DownloadTask
    private let dispatcher:CallbackDispatcher


     init(blockIndex:Int64,source:Source,outputStream:MultiPointOutputStream,task:DownloadTask){
        this.blockIndex = blockIndex
        this.source = source
        this.readBuffer = Array<Byte>(task.getReadBufferSize(),{_ => 0})
        this.outputStream = outputStream
        this.task = task
        this.dispatcher = Download4cj.withs().callbackDispatcher()
    }


    public func interceptFetch(chain:DownloadChain):Int64{
        if (chain.getCache().isInterrupt()){
            throw InterruptException.SIGNAL
        }

        // fetch

        var stream = ByteArrayStream()

        var fetchLength:Int64 = source.read(stream,task.getReadBufferSize())

        if(fetchLength <= 0){
            return fetchLength
        }

        // write to file
        outputStream.write(blockIndex, stream.readToEnd())


        chain.increaseCallbackBytes(fetchLength)

        if (this.dispatcher.isFetchProcessMoment(task)) {
            chain.flushNoCallbackIncreaseBytes()
        }

        return fetchLength

    }


}
