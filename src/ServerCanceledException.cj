package okdownload

public class ServerCanceledException <: Exception {

     private let responseCode:Int64

    public init(responseCode:Int64,currentOffset:Int64){
        super("Response code can't handled on internal " + responseCode.toString() + " with current offset "+ currentOffset.toString())
        this.responseCode = responseCode
    }


    public func getResponseCode():Int64{
        return responseCode
    }


}
