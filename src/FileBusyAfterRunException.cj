package download4cj

public class FileBusyAfterRunException <: Exception {

    private init(){
        super("File busy after run")
    }

    static let SIGNAL:FileBusyAfterRunException = FileBusyAfterRunException()
}
