package okdownload

public class ResumeFailedException <: Exception{

    private let resumeFailedCause:ResumeFailedCause


    public init(cause:ResumeFailedCause){
        this.resumeFailedCause = cause
    }

    //------


}
