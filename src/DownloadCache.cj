package okdownload

public open class DownloadCache {

    private var redirectLocation:String
    private let outputStream:Option<MultiPointOutputStream>

    private var preconditionFailed:Bool
    private var userCanceled:Bool
    private var serverCanceled:Bool
    private var unknownError:Bool
    private var fileBusyAfterRun:Bool
    private var preAllocateFailed:Bool

    private var realCause:Option<IOException>

    init(outputStream:Option<MultiPointOutputStream>){
        this.outputStream = outputStream
        this.redirectLocation = ""
        this.preconditionFailed = false
        this.userCanceled = false
        this.serverCanceled = false
        this.unknownError = false
        this.fileBusyAfterRun = false
        this.preAllocateFailed = false
        this.realCause = Option<IOException>.None
    }

    func getOutputStream():MultiPointOutputStream{
        if(let Some(_) = outputStream){
        }else{
            throw IllegalArgumentException()
        }
        return outputStream.getOrThrow()
    }

    func setRedirectLocation(redirectLocation:String):Unit{
        this.redirectLocation = redirectLocation
    }

    func getRedirectLocation():Option<String>{
        return redirectLocation
    }

    func isPreconditionFailed():Bool{
        return preconditionFailed
    }

    func isUserCanceled():Bool{
        return userCanceled
    }

    func isServerCanceled():Bool{
        return serverCanceled
    }

    func isUnknownError():Bool{
        return unknownError
    }


    func isFileBusyAfterRun():Bool{
        return fileBusyAfterRun
    }

    func isPreAllocateFailed():Bool{
        return preAllocateFailed
    }

    func getRealCause():IOException{
        return realCause.getOrThrow()
    }

    func isInterrupt():Bool{
         return preconditionFailed || userCanceled || serverCanceled || unknownError|| fileBusyAfterRun || preAllocateFailed
    }

    func setUserCanceled():Unit{
        this.userCanceled = true
    }

    func setUnknownError(realCause:IOException):Unit{
         this.unknownError = true
        this.realCause = realCause
    }
}
