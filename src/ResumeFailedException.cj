package okdownload

public class ResumeFailedException <: Exception{

    private let resumeFailedCause:ResumeFailedCause


     init(cause:ResumeFailedCause){
        this.resumeFailedCause = cause
    }

}
