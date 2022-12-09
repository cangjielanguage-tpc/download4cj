package okdownload

public class FileBusyAfterRunException <: Exception {

    private init(){
        super("File busy after run")
    }

    public static let SIGNAL:FileBusyAfterRunException = FileBusyAfterRunException()
}
