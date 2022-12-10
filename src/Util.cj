package okdownload

public class Util{

    public static let CHUNKED_CONTENT_LENGTH:Int64 = -1
    public static let RANGE_NOT_SATISFIABLE:Int64 = 416

    public static let METHOD_HEAD:String = "HEAD"
    public static let VERSION_NAME:String = "1.0.7"
    public static let USER_AGENT:String = "User-Agent"


    public static let ETAG:String = "Etag"
    public static let IF_MATCH:String  = "If-Match"
    public static let RANGE:String = "Range"
    public static let ACCEPT_RANGES:String = "Accept-Ranges"

    public static let VALUE_CHUNKED:String = "chunked"
    public static let CONTENT_RANGE:String = "Content-Range"
    public static let TRANSFER_ENCODING:String = "Transfer-Encoding"
    public static let CONTENT_DISPOSITION:String = "Content-Disposition"
    public static let CONTENT_LENGTH:String = "Content-Length"





    public static let HTTP_PRECON_FAILED:Int64 = 412
    public static let HTTP_CREATED:Int64 = 201
    public static let HTTP_RESET:Int64 = 205
    public static let HTTP_PARTIAL:Int64 = 206
    public static let HTTP_OK:Int64 = 200


    public static func isUriFileScheme(uri:URL):Bool{
        return "file".equals(uri.scheme)
    }

    public static func isEmpty(str:Option<String>):Bool{
        if(let Some(v) = str){
            if(v.size == 0){
                return true
            }else{
                return false
            }
        }else{
            return true
        }
    }


    //------



    public static func d(tag:String,msg:String):Unit{
        let logger:SimpleLogger = SimpleLogger()
        logger.log(LogLevel.DEBUG,tag+"--"+msg)
    }


    //------



    public static func assembleBlock(task:DownloadTask,info:BreakpointInfo,instanceLength:Int64,isAcceptRange:Bool):Unit{
        let blockCount:Int64
        if (OkDownload.withs().downloadStrategy().isUseMultiBlock(isAcceptRange)) {
            println("isMulti")
            blockCount = OkDownload.withs().downloadStrategy().determineBlockCount(task, instanceLength)
            println("isMulti"+blockCount.toString())
        } else {
            blockCount = 1
        }
        info.resetBlockInfos()
        let eachLength:Int64 =  instanceLength / blockCount
        var startOffset:Int64 = 0
        var contentLength:Int64 = 0
        for(i in 0..blockCount){
            startOffset = startOffset + contentLength
            if(i == 0){
                let remainLength:Int64 = instanceLength % blockCount
                contentLength = eachLength + remainLength
            }else{
                 contentLength = eachLength
            }
            let blockInfo:BlockInfo = BlockInfo(startOffset, contentLength)
            println("startOffset="+startOffset.toString()+"------contentLength"+contentLength.toString())
            info.addBlock(blockInfo)
        }
    }



    private static let CONTENT_LENGTH_FROM_CONTENT_RANGE_PATTERN:Regex = Regex(#"bytes (\d+)-(\d+)/\d+"#)


    public static func parseContentLengthFromContentRange(contentRange:Option<String>):Int64{
        //------

        return CHUNKED_CONTENT_LENGTH
    }



    public static func parseContentLength(contentLength:Option<String>):Int64{
        if(let Some(i) = contentLength){

        }else{
            return CHUNKED_CONTENT_LENGTH
        }

        try {
            return Int64.parse(contentLength.getOrThrow())
        } catch (ignored:Exception) {
            //Util.d("Util", "parseContentLength failed parse for '" + contentLength.getOrThrow() + "'")
        }

        return CHUNKED_CONTENT_LENGTH

    }





    public static func inspectUserHeader(headerField:HashMap<String,ArrayList<String>>):Unit{
        if(headerField.contains(IF_MATCH) || headerField.contains(RANGE)){
            throw  IOException(IF_MATCH + " and " + RANGE + " only can be handle by internal!")
        }
    }


    public static func addUserRequestHeaderField(userHeaderField:HashMap<String,ArrayList<String>>,connection:DownloadConnection):Unit{
        inspectUserHeader(userHeaderField)
        addRequestHeaderFields(userHeaderField,connection)
    }


    public static func addRequestHeaderFields(userHeaderField:HashMap<String,ArrayList<String>>,connection:DownloadConnection):Unit{
        var mapKeys:Keys<String> =  userHeaderField.keys()
        var itera:Iterator<String> =  mapKeys.iterator()
        while(true){
            var optKey:Option<String> = itera.next()
            match(optKey){
                case Some(v)=>
                     println("")
                     //------
                case None => break
            }
        }
    }



    public static func addDefaultUserAgent(connection:DownloadConnection):Unit{

        let userAgent:String = "OkDownload/"+VERSION_NAME
        connection.addHeader(USER_AGENT, userAgent)

    }


    public static func isCorrectFull(fetchedLength:Int64,contentLength:Int64):Bool{
        return fetchedLength == contentLength
    }

    public static func resetBlockIfDirty(info:BlockInfo):Unit{
        var isDirty:Bool = false

        if (info.getCurrentOffset() < 0) {
            isDirty = true
        } else if (info.getCurrentOffset() > info.getContentLength()) {
            isDirty = true
        }

        if (isDirty) {
            //w("resetBlockIfDirty", "block is dirty so have to reset: " + info.toString())
            info.resetBlock()
        }

    }



}
