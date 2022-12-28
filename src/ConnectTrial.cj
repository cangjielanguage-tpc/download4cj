package okdownload


public class ConnectTrial{

    private static let TAG:String = "ConnectTrial"
    private let task:DownloadTask
    private let info:BreakpointInfo
    private var acceptRange:Bool
    private var instanceLength:Int64
    private var responseEtag:String
    private var responseFilename:String
    private var responseCode:Int64

    public init(task:DownloadTask,info:BreakpointInfo){
        this.task = task
        this.info = info
        this.acceptRange = false
        this.instanceLength = 0
        this.responseEtag = ""
        this.responseFilename = ""
        this.responseCode = 0
    }

    public func executeTrial():Unit{
        println("mmmmm14")
        var connection:DownloadConnection = OkDownload.withs().connectionFactory().create(task.getUrl())
        var isNeedTrialHeadMethod:Bool = false
        println("mmmmm15")
        try{

            if(!Util.isEmpty(info.getEtag())){
                connection.addHeader(Util.IF_MATCH, info.getEtag().getOrThrow())
            }
            connection.addHeader(Util.RANGE, "bytes=0-0")
            println("mmmmm16")
            let userHeader:Option<HashMap<String,ArrayList<String>>> = task.getHeaderMapFields()
            if(let Some(i) = userHeader){
                 Util.addUserRequestHeaderField(userHeader.getOrThrow(), connection)
            }
            println("mmmmm17")
            let listener:DownloadListener = OkDownload.withs().callbackDispatcher().dispatch()
            let requestProperties:HashMap<String,ArrayList<String>> = connection.getRequestProperties()
            println("mmmmm18")

            listener.connectTrialStart(task, requestProperties)
            println("mmmmm19")
            let connected:DownloadConnectionConnected = connection.execute()
            println("mmmmm20")

            if(let Some(i) = connected.getRedirectLocation()){
                  task.setRedirectLocation(connected.getRedirectLocation().getOrThrow())
            }else{

            }

             println("mmmmm21")

            //Util.d(TAG, "task[" + task.getId().toString() + "] redirect location: "+ task.getRedirectLocation())
            this.responseCode = connected.getResponseCode()
            println("mmmmm22Code"+responseCode.toString())

            this.acceptRange = isAcceptRanges(connected)
            this.instanceLength = findInstanceLength(connected)
            this.responseEtag = findEtag(connected)
            this.responseFilename = findFilename(connected)
             println("mmmmm23")
             var responseHeader: Option<HashMap<String, ArrayList<String>>> = connected.getResponseHeaderFields()
             if(let Some(i) = responseHeader){

             }else{
                 responseHeader = HashMap<String, ArrayList<String>>()
             }
              println("mmmmm24")
             listener.connectTrialEnd(task, responseCode, responseHeader.getOrThrow())
             println("mmmmm25")
             isNeedTrialHeadMethod = isNeedTrialHeadMethodForInstanceLength(instanceLength,connected)
            println("mmmmm26"+isNeedTrialHeadMethod.toString())
        }finally {
            connection.release()
        }

        if (isNeedTrialHeadMethod) {
            trialHeadMethodForInstanceLength()
        }

    }



    public func getInstanceLength():Int64{
        return this.instanceLength
    }



    public func isAcceptRange():Bool{
        return this.acceptRange
    }



    public func isChunked():Bool{
        return this.instanceLength == Util.CHUNKED_CONTENT_LENGTH
    }



    public func getResponseEtag():String{
        return responseEtag
    }


    public func getResponseFilename():String{
        return responseFilename
    }


    public func getResponseCode():Int64{
        return responseCode
    }

    //------




    private static func isAcceptRanges(connected:DownloadConnectionConnected):Bool{
        if (connected.getResponseCode() == Util.HTTP_PARTIAL){
            return true
        }
        try{
            let acceptRanges:String = connected.getResponseHeaderField(Util.ACCEPT_RANGES).getOrThrow()
            return "bytes".equals(acceptRanges)
        }catch(e:Exception){
            return false
        }

    }




    private static func findFilename(connected:DownloadConnectionConnected):String{
        let optStr:Option<String> = connected.getResponseHeaderField(Util.CONTENT_DISPOSITION)
        if(let Some(i) = optStr){
            return parseContentDisposition(optStr).getOrThrow()
        }else{
            return ""
        }
    }



    private static let CONTENT_DISPOSITION_QUOTED_PATTERN:Regex = Regex("attachment;\\s*filename\\s*=\\s*\"([^\"]*)\"")
    private static let CONTENT_DISPOSITION_NON_QUOTED_PATTERN:Regex = Regex("attachment;\\s*filename\\s*=\\s*(.*)")



    private static func parseContentDisposition(contentDisposition:Option<String>):Option<String>{

        if(let Some(i) = contentDisposition){

        }else{
            return Option<String>.None
        }

        try{

            var fileName:Option<String> = Option<String>.None
            var isM:Bool = false
            match(CONTENT_DISPOSITION_QUOTED_PATTERN.matches(contentDisposition.getOrThrow())){
                case Some(r)
                    => fileName = r.matchStr()
                case None
                    => isM = true
            }

            if(isM){
                match(CONTENT_DISPOSITION_NON_QUOTED_PATTERN.matches(contentDisposition.getOrThrow())){
                    case Some(r)
                        => fileName = r.matchStr()
                    case None
                        => fileName = Option<String>.None
                 }
            }

            if(let Some(i) = fileName){
                if(fileName.getOrThrow().contains("../")){
                    throw  DownloadSecurityException("The filename [" + fileName.getOrThrow() + "] from the response is not allowable, because it contains '../', which can raise the directory traversal vulnerability");
                }
            }

            return fileName

        }catch(ex:IllegalStateException){

        }

        return Option<String>.None

    }




    private static func findEtag(connected:DownloadConnectionConnected):String{
        try{
            return connected.getResponseHeaderField(Util.ETAG).getOrThrow()
        }catch(e:Exception){
            return ""
        }
    }



    private static func findInstanceLength(connected:DownloadConnectionConnected):Int64{

        let instanceLength:Int64 = parseContentRangeFoInstanceLength(connected.getResponseHeaderField(Util.CONTENT_RANGE))
        if (instanceLength != Util.CHUNKED_CONTENT_LENGTH){
            return instanceLength
        }

        //------


        return Util.CHUNKED_CONTENT_LENGTH

    }

    func isNeedTrialHeadMethodForInstanceLength(oldInstanceLength:Int64,connected:DownloadConnectionConnected):Bool{
        if (oldInstanceLength != Util.CHUNKED_CONTENT_LENGTH) {
            // the instance length already has certain value.
            return false
        }

        //------

        return true
    }



    func trialHeadMethodForInstanceLength():Unit{
        //------

    }



    private static func parseTransferEncoding(transferEncoding:Option<String>):Bool{
        //------

        return true

    }



    private static func parseContentRangeFoInstanceLength(contentRange:Option<String>):Int64{
        if(let Some(i) = contentRange){

        }else{
            return Util.CHUNKED_CONTENT_LENGTH
        }

        let session: Array<String> = contentRange.getOrThrow().split("/")
        if(session.size >= 2){
            try {
                return Int64.parse(session[1])
            } catch (e:Exception) {
                //Util.w(TAG, "parse instance length failed with " + contentRange.getOrThrow().toString())
            }
        }
         return -1
    }


}
