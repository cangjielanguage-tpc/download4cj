package okdownload

public class FileNameHolder <: Hashable & Equatable<FileNameHolder> {

    private var filename:Option<String>
    private let filenameProvidedByConstruct:Bool

     init(){
        this.filename = Option<String>.None
        this.filenameProvidedByConstruct = false
    }

     init(filename:String){
        this.filename = filename
        this.filenameProvidedByConstruct = true
    }



     func get():Option<String>{
        return filename
    }



    public operator func ==(holder: FileNameHolder): Bool{
        //------

         return true
    }

    public operator func !=(holder: FileNameHolder): Bool{

        return false
    }

    public func hashCode(): Int64{

         return 0
    }
}
