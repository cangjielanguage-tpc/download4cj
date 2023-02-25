package okdownload

public abstract class IdentifiedTask{

    static  let EMPTY_URL: String = ""
    static  let EMPTY_FILEPATH : String = "" //文件路径为空

     func getId(): Int64

     func getUrl(): String

    protected func getProvidedPathFile():Option<File>

     func getParentFile():Directory

     func getFilename():Option<String>


     func compareIgnoreId(another : IdentifiedTask):Bool{
        try{
            if(!getUrl().equals(another.getUrl())){
                return false
            }
            if(getUrl().equals(EMPTY_URL) || getParentFile().info.path.toString().equals(EMPTY_FILEPATH)){
                return false
            }
            if(getProvidedPathFile().getOrThrow().info == another.getProvidedPathFile().getOrThrow().info){
                return true
            }
            if(getParentFile().info != another.getParentFile().info){
                return false
            }
            let fileName : String = getFilename().getOrThrow()
            let anotherFilename : String = another.getFilename().getOrThrow()
            return anotherFilename.equals(fileName)
        }catch(e:Exception){
            return false
        }
    }
}
