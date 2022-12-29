package okdownload

public class BreakpointInterceptor <: InterceptorConnect & InterceptorFetch{


    private static let TAG:String = "BreakpointInterceptor"
    //var doneCount:AtomicInt64 = AtomicInt64(0)

    public func interceptConnect(chain:DownloadChain):Option<DownloadConnectionConnected>{
        let connected:DownloadConnectionConnected =  chain.processConnect()
        let info:BreakpointInfo = chain.getInfo()
        //totalBlockCount = info.getBlockCount()
        if(chain.getCache().isInterrupt()){
            throw InterruptException.SIGNAL
        }


        if(info.getBlockCount() == 1 && !info.isChunked()){
             // only one block to download this resource
            // use this block response header instead of trial result if they are different.


            let blockInstanceLength:Int64 = getExactContentLengthRangeFrom0(connected)
            let infoInstanceLength:Int64 =  info.getTotalLength()
            if (blockInstanceLength > 0 && blockInstanceLength != infoInstanceLength) {
                //------

            }
        }
        // update for connected.
        let store:DownloadStore = chain.getDownloadStore()
        try {
            if (!store.update(info)) {
                throw IOException("Update store failed!")
            }
        } catch (e:Exception) {
            throw IOException("Update store failed!"+e.toString())
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
                fetchLength += processFetchLength
                //if (processFetchLength == -1) {
                if (fetchLength ==  contentLength) {
                    //doneCount.fetchAdd(1)
                    // if(doneCount.load() == totalBlockCount){
                    //     break
                    // }
                    break
                }
            }
        }catch(e:Exception){
            println("reason="+e.message.toString())
        }finally{
            // finish
            chain.flushNoCallbackIncreaseBytes()
            if (!chain.getCache().isUserCanceled()){
                 outputStream.done(blockIndex)
            }
        }

        if (isNotChunked) {
            // local persist data check.
            outputStream.inspectComplete(blockIndex)
            // response content length check.
            if (fetchLength != contentLength) {
                throw  IOException("Fetch-length isn't equal to the response content-length, "+ fetchLength.toString() + "!= " + contentLength.toString())
            }
        }

        return fetchLength

    }


    private static let CONTENT_RANGE_RIGHT_VALUE:Regex = Regex(".*\\d+ *- *(\\d+) */ *\\d+")




    func getExactContentLengthRangeFrom0(connected:DownloadConnectionConnected):Int64{
        let contentRangeField:String = connected.getResponseHeaderField(Util.CONTENT_RANGE).getOrThrow()
        var contentLength:Int64 = -1
        if (!Util.isEmpty(contentRangeField)){
            let rightRange:Int64 = getRangeRightFromContentRange(contentRangeField)
            if (rightRange > 0){
                contentLength = rightRange + 1
            }
        }
        if (contentLength < 0) {
            //------

        }
        return contentLength
    }


    static func getRangeRightFromContentRange(contentRange:String):Int64{
        //  match(CONTENT_RANGE_RIGHT_VALUE.matches(contentRange)){
        //     case Some(r)
        //         =>
        //         println("xxxxxxx03"+r.matchStr())
        //         return Int64.parse(r.matchStr())
        //     case None
        //         =>
        //         println("xxxxxxx04")
        //         return -1
        // }

         let r = CONTENT_RANGE_RIGHT_VALUE.matcher(contentRange)
         let matchDataArray:Option<Array<MatchData>> = r.findAll()
                match(matchDataArray){
                    case Some(md)
                        =>
                        //println("xxxxxxx031"+md.matchStr().toString())
                        return Int64.parse(md.get(0).getOrThrow().matchStr(1))
                    case None
                        =>
                        return -1
                }
        }
}
