package okdownload

public class BreakpointInterceptor <: InterceptorConnect & InterceptorFetch{


    private static let TAG:String = "BreakpointInterceptor"

    public func interceptConnect(chain:DownloadChain):Option<DownloadConnectionConnected>{
        let connected:DownloadConnectionConnected =  chain.processConnect()
        let info:BreakpointInfo = chain.getInfo()
        if(chain.getCache().isInterrupt()){
            throw InterruptException.SIGNAL
        }
        if(info.getBlockCount() == 1 && !info.isChunked()){
            let blockInstanceLength:Int64 = getExactContentLengthRangeFrom0(connected)
            let infoInstanceLength:Int64 =  info.getTotalLength()
              if(blockInstanceLength > 0 && blockInstanceLength != infoInstanceLength) {
                Util.d(TAG, "SingleBlock special check: the response instance-length["+blockInstanceLength.toString()+"] isn't equal to the instance length from trial-connection["+infoInstanceLength.toString()+"]")
                let blockInfo:BlockInfo =  info.getBlock(0).getOrThrow()
                var isFromBreakpoint:Bool = blockInfo.getRangeLeft() != 0
                let newBlockInfo:BlockInfo = BlockInfo(0,blockInstanceLength)
                info.resetBlockInfos()
                info.addBlock(newBlockInfo)
                if (isFromBreakpoint) {
                    let msg:String = "Discard breakpoint because of on this special case, we have to download from beginning"
                    Util.d(TAG, msg)
                    throw RetryException(msg)
                }
                OkDownload.withs().callbackDispatcher().dispatch().downloadFromBeginning(chain.getTask())
            }
        }
        let store:DownloadStore = chain.getDownloadStore()
        try {
            if (!store.update(info)) {
                throw ReadWriteException("Update store failed!")
            }
        } catch (e:Exception) {
            throw ReadWriteException("Update store failed!"+e.toString())
        }
        return connected

    }



    public func interceptFetch(chain:DownloadChain):Int64{
        let contentLength:Int64 = chain.getResponseContentLength()
        let blockIndex:Int64 = chain.getBlockIndex()
        let isNotChunked:Bool = contentLength != Util.CHUNKED_CONTENT_LENGTH
        var fetchLength:Int64 = 0
        var processFetchLength:Int64 = 0
        let outputStream:MultiPointOutputStream = chain.getOutputStream()
        try {
            while (true) {
                processFetchLength = chain.loopFetch()
                if (processFetchLength <= 0) {
                    break
                }
                fetchLength += processFetchLength
            }
        }catch(e:Exception){
            println("reason="+e.message.toString())
        }finally{
            chain.flushNoCallbackIncreaseBytes()
            if (!chain.getCache().isUserCanceled()){
                 outputStream.done(blockIndex)
            }
        }
        if (isNotChunked) {
            outputStream.inspectComplete(blockIndex)
            if (fetchLength != contentLength) {
                throw  ReadWriteException("Fetch-length isn't equal to the response content-length, "+ fetchLength.toString() + "!= " + contentLength.toString())
            }
        }
        return fetchLength
    }


    private static let CONTENT_RANGE_RIGHT_VALUE:Regex = Regex(".*\\d+ *- *(\\d+) */ *\\d+")


    func getExactContentLengthRangeFrom0(connected:DownloadConnectionConnected):Int64{
        let contentRangeField:Option<String> = connected.getResponseHeaderField(Util.CONTENT_RANGE)
        var contentLength:Int64 = -1
        if (!Util.isEmpty(contentRangeField)){
            let rightRange:Int64 = getRangeRightFromContentRange(contentRangeField.getOrThrow())
            if (rightRange > 0){
                contentLength = rightRange + 1
            }
        }
        if (contentLength < 0) {
            let contentLengthField:Option<String> = connected.getResponseHeaderField(Util.CONTENT_LENGTH)
            if (!Util.isEmpty(contentLengthField)) {
                contentLength = Int64.parse(contentLengthField.getOrThrow())
            }
        }
        return contentLength
    }


    static func getRangeRightFromContentRange(contentRange:String):Int64{
         let r = CONTENT_RANGE_RIGHT_VALUE.matcher(contentRange)
         let matchDataArray:Option<Array<MatchData>> = r.findAll()
                match(matchDataArray){
                    case Some(md)
                        =>
                        return Int64.parse(md.get(0).getOrThrow().matchStr(1))
                    case None
                        =>
                        return -1
                }
        }
}
