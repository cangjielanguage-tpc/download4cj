package download4cj

public class PreError <: DownloadCache{

    init(realCause:IOException){
         super(Option<MultiPointOutputStream>.None)
         setUnknownError(realCause)
    }
}
