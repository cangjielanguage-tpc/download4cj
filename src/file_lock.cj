/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights resvered.
 */

package download4cj

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


}
