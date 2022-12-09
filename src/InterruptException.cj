package okdownload

public class InterruptException <: Exception {

    private init(){
        super("Interrupted")
    }

    public static let SIGNAL:InterruptException = InterruptException()
}
