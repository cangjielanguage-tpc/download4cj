package download4cj

public class Util{

     static let CHUNKED_CONTENT_LENGTH:Int64 = -1
     static let RANGE_NOT_SATISFIABLE:Int64 = 416

     static let METHOD_HEAD:String = "HEAD"
     static let VERSION_NAME:String = "1.0.7"
     static let USER_AGENT:String = "User-Agent"


     static let ETAG:String = "Etag"
     static let IF_MATCH:String  = "If-Match"
     static let RANGE:String = "Range"
     static let ACCEPT_RANGES:String = "Accept-Ranges"

     static let VALUE_CHUNKED:String = "chunked"
     static let CONTENT_RANGE:String = "Content-Range"
     static let TRANSFER_ENCODING:String = "Transfer-Encoding"
     static let CONTENT_DISPOSITION:String = "Content-Disposition"
     static let CONTENT_LENGTH:String = "Content-Length"





     static let HTTP_PRECON_FAILED:Int64 = 412
     static let HTTP_CREATED:Int64 = 201
     static let HTTP_RESET:Int64 = 205
     static let HTTP_PARTIAL:Int64 = 206
     static let HTTP_OK:Int64 = 200


     static func isUriFileScheme(uri:String):Bool{
        return uri.startsWith("file")
    }

     static func isEmpty(str:Option<String>):Bool{
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





     static func d(tag:String,msg:String):Unit{
        let logger:SimpleLogger = SimpleLogger()
        logger.log(LogLevel.DEBUG,tag+"--"+msg)
    }





     static func assembleBlock(task:DownloadTask,info:BreakpointInfo,instanceLength:Int64,isAcceptRange:Bool):Unit{
        let blockCount:Int64
        if (Download4cj.withs().downloadStrategy().isUseMultiBlock(isAcceptRange)) {
            blockCount = Download4cj.withs().downloadStrategy().determineBlockCount(task, instanceLength)
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
            info.addBlock(blockInfo)
        }
    }



    private static let CONTENT_LENGTH_FROM_CONTENT_RANGE_PATTERN:Regex = Regex(#"bytes (\d+)-(\d+)/\d+"#)



     static func parseContentLength(contentLength:Option<String>):Int64{
        if(let Some(_) = contentLength){
        }else{
            return CHUNKED_CONTENT_LENGTH
        }
        try {
            return Int64.parse(contentLength.getOrThrow())
        } catch (ignored:Exception) {
            Util.d("Util", "parseContentLength failed parse for '" + contentLength.getOrThrow() + "'")
        }

        return CHUNKED_CONTENT_LENGTH

    }





     static func inspectUserHeader(headerField:HashMap<String,ArrayList<String>>):Unit{
        if(headerField.contains(IF_MATCH) || headerField.contains(RANGE)){
            throw  ReadWriteException(IF_MATCH + " and " + RANGE + " only can be handle by internal!")
        }
    }


     static func addUserRequestHeaderField(userHeaderField:HashMap<String,ArrayList<String>>,connection:DownloadConnection):Unit{
        inspectUserHeader(userHeaderField)
        addRequestHeaderFields(userHeaderField,connection)
    }


     static func addRequestHeaderFields(userHeaderField:HashMap<String,ArrayList<String>>,connection:DownloadConnection):Unit{
        var mapKeys:Keys<String> =  userHeaderField.keys()
        var itera:Iterator<String> =  mapKeys.iterator()
        while(true){
            var optKey:Option<String> = itera.next()
            match(optKey){
                case Some(v)=>
                      let values:ArrayList<String> = userHeaderField.get(v).getOrThrow()
                    for(value in values){
                        connection.addHeader(v, value)
                    }
                case None => break
            }
        }
    }



     static func addDefaultUserAgent(connection:DownloadConnection):Unit{

        let userAgent:String = "Download4cj/"+VERSION_NAME
        connection.addHeader(USER_AGENT, userAgent)

    }


     static func isCorrectFull(fetchedLength:Int64,contentLength:Int64):Bool{
        return fetchedLength == contentLength
    }

     static func resetBlockIfDirty(info:BlockInfo):Unit{
        var isDirty:Bool = false

        if (info.getCurrentOffset() < 0) {
            isDirty = true
        } else if (info.getCurrentOffset() > info.getContentLength()) {
            isDirty = true
        }

        if (isDirty) {
            info.resetBlock()
        }

    }



}
