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
