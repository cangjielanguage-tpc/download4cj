package download4cj


public class ConnectTrial{

    private static let TAG:String = "ConnectTrial"
    private let task:DownloadTask
    private let info:BreakpointInfo
    private var acceptRange:Bool
    private var instanceLength:Int64
    private var responseEtag:String
    private var responseFilename:String
    private var responseCode:Int64

    init(task:DownloadTask,info:BreakpointInfo){
        this.task = task
        this.info = info
        this.acceptRange = false
        this.instanceLength = 0
        this.responseEtag = ""
        this.responseFilename = ""
        this.responseCode = 0
    }

    func executeTrial():Unit{
        var connection:DownloadConnection = Download4cj.withs().connectionFactory().create(task.getUrl())
        var isNeedTrialHeadMethod:Bool = false
        try{
            connection.addHeader(Util.RANGE, "bytes=0-0")
            let userHeader:Option<HashMap<String,ArrayList<String>>> = task.getHeaderMapFields()
            if(let Some(_) = userHeader){
                 Util.addUserRequestHeaderField(userHeader.getOrThrow(), connection)
            }
            let listener:DownloadListener = Download4cj.withs().callbackDispatcher().dispatch()
            let requestProperties:HashMap<String,ArrayList<String>> = connection.getRequestProperties()

            listener.connectTrialStart(task, requestProperties)
            let connected:DownloadConnectionConnected = connection.execute()

            if(let Some(_) = connected.getRedirectLocation()){
                  task.setRedirectLocation(connected.getRedirectLocation().getOrThrow())
            }
            this.responseCode = connected.getResponseCode()
            this.acceptRange = isAcceptRanges(connected)
            this.instanceLength = findInstanceLength(connected)
            this.responseEtag = findEtag(connected)
            this.responseFilename = findFilename(connected)
            var responseHeader: Option<HashMap<String, ArrayList<String>>> = connected.getResponseHeaderFields()
            if(let Some(_) = responseHeader){
            }else{
                 responseHeader = HashMap<String, ArrayList<String>>()
            }
             listener.connectTrialEnd(task, responseCode, responseHeader.getOrThrow())
             isNeedTrialHeadMethod = isNeedTrialHeadMethodForInstanceLength(instanceLength)
        }finally {
            connection.release()
        }
    }

    func getInstanceLength():Int64{
        return this.instanceLength
    }

    func isAcceptRange():Bool{
        return this.acceptRange
    }

    func isChunked():Bool{
        return this.instanceLength == Util.CHUNKED_CONTENT_LENGTH
    }

    func getResponseEtag():String{
        return responseEtag
    }

    func getResponseFilename():String{
        return responseFilename
    }

    func getResponseCode():Int64{
        return responseCode
    }

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
        if(let Some(_) = optStr){
            return parseContentDisposition(optStr).getOrThrow()
        }else{
            return ""
        }
    }

    private static let CONTENT_DISPOSITION_QUOTED_PATTERN:Regex = Regex("attachment;\\s*filename\\s*=\\s*\"([^\"]*)\"")
    private static let CONTENT_DISPOSITION_NON_QUOTED_PATTERN:Regex = Regex("attachment;\\s*filename\\s*=\\s*(.*)")

    private static func parseContentDisposition(contentDisposition:Option<String>):Option<String>{
        if(let Some(_) = contentDisposition){
        }else{
            return Option<String>.None
        }
        try{
            var fileName:Option<String> = Option<String>.None
            var isM:Bool = false
            var m0 = CONTENT_DISPOSITION_QUOTED_PATTERN.matcher(contentDisposition.getOrThrow())
            var matchData0 = m0.find()
            match(matchData0){
                case Some(s) =>
                    if (s.groupNumber() > 0) {
                        fileName = s.matchStr(1)
                    }else{
                        fileName = Option<String>.None
                    }
                case None =>
                    isM = true
                }
            if(let Some(_) = fileName){
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
        return Util.CHUNKED_CONTENT_LENGTH
    }

    func isNeedTrialHeadMethodForInstanceLength(oldInstanceLength:Int64):Bool{
        if (oldInstanceLength != Util.CHUNKED_CONTENT_LENGTH) {
            // the instance length already has certain value.
            return false
        }
        return true
    }

    private static func parseContentRangeFoInstanceLength(contentRange:Option<String>):Int64{
        if(let Some(_) = contentRange){
        }else{
            return Util.CHUNKED_CONTENT_LENGTH
        }
        let session: Array<String> = contentRange.getOrThrow().split("/")
        if(session.size >= 2){
            try {
                return Int64.parse(session[1])
            } catch (e:Exception) {
                Util.d(TAG, "parse instance length failed with " + contentRange.getOrThrow().toString())
            }
        }
         return -1
    }
}
