package okdownload

public class FileLock {

    let m:MultiConditionMonitor = MultiConditionMonitor()

    private static let TAG:String = "FileLock"
    private let fileLockCountMap: HashMap<String, AtomicInt64>

    init(fileLockCountMap:HashMap<String,AtomicInt64>){
        this.fileLockCountMap = fileLockCountMap
    }

    init(){
        this(HashMap<String, AtomicInt64>())
    }


    //------



    //------


}
