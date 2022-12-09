package okdownload

public class PreAllocateException <: Exception {

 private let requireSpace:Int64
 private let freeSpace:Int64



   public init(requireSpace:Int64,freeSpace:Int64){
    super("There is Free space less than Require space: " + freeSpace.toString() + " < " + requireSpace.toString())
    this.requireSpace = requireSpace
    this.freeSpace = freeSpace
   }


   public func getRequireSpace():Int64{
        return requireSpace
   }

   public func getFreeSpace():Int64{
        return freeSpace
   }


}
