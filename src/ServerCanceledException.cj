package download4cj

public class ServerCanceledException <: Exception {

     private let responseCode:Int64

     init(responseCode:Int64,currentOffset:Int64){
        super("Response code can't handled on internal " + responseCode.toString() + " with current offset "+ currentOffset.toString())
        this.responseCode = responseCode
    }

}
