package okdownload

public class InterruptException <: Exception {

    private init(){
        super("Interrupted")
    }

    static let SIGNAL:InterruptException = InterruptException()
}
