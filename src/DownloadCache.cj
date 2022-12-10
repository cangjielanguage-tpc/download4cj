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

    //------


    func getOutputStream():MultiPointOutputStream{
        if(let Some(i) = outputStream){

        }else{
            throw IllegalArgumentException()
        }
        return outputStream.getOrThrow()
    }


    func setRedirectLocation(redirectLocation:String):Unit{
        //------

    }

    func getRedirectLocation():Option<String>{
        return redirectLocation
    }

    func isPreconditionFailed():Bool{
        return preconditionFailed
    }

    public func isUserCanceled():Bool{
        return userCanceled
    }

    public func isServerCanceled():Bool{
        return serverCanceled
    }



    public func isUnknownError():Bool{
        return unknownError
    }


    public func isFileBusyAfterRun():Bool{
        return fileBusyAfterRun
    }



      public func isPreAllocateFailed():Bool{
        return preAllocateFailed
    }



    func getRealCause():IOException{
        return realCause.getOrThrow()
    }



    //------


    public func isInterrupt():Bool{
         return preconditionFailed || userCanceled || serverCanceled || unknownError
                || fileBusyAfterRun || preAllocateFailed
    }


    public func setPreconditionFailed(realCause:IOException):Unit{
        //------

    }



    func setUserCanceled():Unit{
        //------
    }



    public func setFileBusyAfterRun():Unit{
        //------

    }



    public func setServerCanceled(realCause:IOException):Unit{
        //------

    }


    public func setUnknownError(realCause:IOException):Unit{
        //------

    }



    public func setPreAllocateFailed(realCause:IOException):Unit{
        //------

    }



    public func catchException(e:IOException):Unit{
        //------

    }

















}
