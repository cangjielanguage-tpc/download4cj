package download4cj

public class ResumeFailedException <: Exception{

    private let resumeFailedCause:ResumeFailedCause


     init(cause:ResumeFailedCause){
        this.resumeFailedCause = cause
    }

}
