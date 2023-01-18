package okdownload

public class HeaderInterceptor <: InterceptorConnect{

    private static let TAG:String = "HeaderInterceptor"


    public func interceptConnect(chain:DownloadChain):Option<DownloadConnectionConnected>{
        let info:BreakpointInfo = chain.getInfo()
        let connection:DownloadConnection =  chain.getConnectionOrCreate()
        let task:DownloadTask = chain.getTask()
        // add user customize header
        let userHeader:Option<HashMap<String,ArrayList<String>>> =  task.getHeaderMapFields()

        var isUserHeaderEmpty:Bool = true
        if(let Some(i) = userHeader){
            //不为空
            isUserHeaderEmpty = false
            Util.addUserRequestHeaderField(userHeader.getOrThrow(), connection)
        }

        if(isUserHeaderEmpty || !userHeader.getOrThrow().contains(Util.USER_AGENT)){
            Util.addDefaultUserAgent(connection)
        }

        // add range header
        let blockIndex:Int64 = chain.getBlockIndex()
        let blockInfo:Option<BlockInfo> =  info.getBlock(blockIndex)
        if(let Some(i) = blockInfo){

        }else{
            throw IOException("No block-info found on " + blockIndex.toString())
        }
        var range:String = "bytes=" + blockInfo.getOrThrow().getRangeLeft().toString() + "-"
        range = range +  blockInfo.getOrThrow().getRangeRight().toString()

        connection.addHeader(Util.RANGE, range)
        Util.d(TAG, "AssembleHeaderRange (" + task.getId().toString() + ") block(" + blockIndex.toString() + ") "+ "downloadFrom(" + blockInfo.getOrThrow().getRangeLeft().toString() + ") currentOffset("  + blockInfo.getOrThrow().getCurrentOffset().toString() + ")")

        // add etag if exist
        let etag:String = info.getEtag().getOrThrow()
        // if(!Util.isEmpty(etag)){
        //     connection.addHeader(Util.IF_MATCH, etag)
        // }

        if (chain.getCache().isInterrupt()) {
            throw InterruptException.SIGNAL
        }

        OkDownload.withs().callbackDispatcher().dispatch().connectStart(task, blockIndex, connection.getRequestProperties())
        var connected:DownloadConnectionConnected = chain.processConnect()

        if (chain.getCache().isInterrupt()) {
            throw InterruptException.SIGNAL
        }

        var responseHeaderFields:Option<HashMap<String,ArrayList<String>>> = connected.getResponseHeaderFields()
        if(let Some(i) = responseHeaderFields){

        }else{
            responseHeaderFields = HashMap<String,ArrayList<String>>()
        }

        OkDownload.withs().callbackDispatcher().dispatch().connectEnd(task, blockIndex,connected.getResponseCode(), responseHeaderFields.getOrThrow())
         // if precondition failed.
        let strategy:DownloadStrategy = OkDownload.withs().downloadStrategy()
        let responseCheck:ResumeAvailableResponseCheck =  strategy.resumeAvailableResponseCheck(connected, blockIndex, info)
         responseCheck.inspect()

        var contentLength:Int64 = 0
        let contentLengthField:Option<String> = connected.getResponseHeaderField(Util.CONTENT_LENGTH)

        var isContentLengthFieldEmpty:Bool = true
        if(let Some(i) = contentLengthField){
            isContentLengthFieldEmpty = false
        }



        if(isContentLengthFieldEmpty || contentLengthField.getOrThrow().size == 0){
            let contentRangeField:String = connected.getResponseHeaderField(Util.CONTENT_RANGE).getOrThrow()
            contentLength = Util.parseContentLengthFromContentRange(contentRangeField)
        }else{
            contentLength = Util.parseContentLength(contentLengthField)
        }

        chain.setResponseContentLength(contentLength)
        return connected

    }

}
