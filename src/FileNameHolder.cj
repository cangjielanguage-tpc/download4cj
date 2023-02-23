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
         if(let Some(v) = filename){
            if(let Some(i) = holder.filename){
                if(v.equals(i)){
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
          }else{
            if(let Some(v) = holder.filename){
                return false
            }else{
                return true
            }
          }
    }

    public operator func !=(holder: FileNameHolder): Bool{

        if(let Some(v) = filename){
            if(let Some(i) = holder.filename){
                if(v.equals(i)){
                    return false
                }else{
                    return true
                }
            }else{
                return true
            }
          }else{
            if(let Some(v) = holder.filename){
                return true
            }else{
                return false
            }
          }
    }

    public func hashCode(): Int64{

         return 0
    }
}
