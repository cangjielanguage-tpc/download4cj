package okdownload

public class BreakpointStoreOnCache <: DownloadStore{


    let m:MultiConditionMonitor = MultiConditionMonitor()
    let m2:MultiConditionMonitor = MultiConditionMonitor()



    private let storedInfos:HashMap<Int64,Option<BreakpointInfo>>
    private let responseFilenameMap:HashMap<String, String>

    private let keyToIdMap:KeyToIdMap

    private let unStoredTasks:HashMap<Int64,Option<IdentifiedTask>>
    private let sortedOccupiedIds:ArrayList<Int64>
    private let fileDirtyList:ArrayList<Int64>

    public init(){
        this(HashMap<Int64,Option<BreakpointInfo>>(),ArrayList<Int64>(),HashMap<String, String>())
    }

    //------


    public init(storedInfos:HashMap<Int64,Option<BreakpointInfo>>,fileDirtyList:ArrayList<Int64>,responseFilenameMap:HashMap<String, String>){
        this.unStoredTasks = HashMap<Int64,Option<IdentifiedTask>>()
        this.storedInfos = storedInfos
        this.fileDirtyList = fileDirtyList
        this.responseFilenameMap = responseFilenameMap
        this.keyToIdMap = KeyToIdMap()
        let count:Int64 = storedInfos.size
        sortedOccupiedIds = ArrayList<Int64>()

        let keyList:Keys<Int64> = storedInfos.keys()
        let itera:Iterator<Int64>  = keyList.iterator()
        while(true){
            var optKey:Option<Int64> = itera.next()
            match(optKey){
                case Some(v)=>
                    let info:Option<BreakpointInfo> =  storedInfos.get(v).getOrThrow()
                    //------

                case None => break
            }
        }
        sortedOccupiedIds.sortBy({rht:Int64,lht:Int64 =>
            //------

            return Ordering.EQ
        },stable:true)
    }

    public func get(id:Int64):Option<BreakpointInfo>{
        if(let Some(i) = storedInfos.get(id)){
            return i.getOrThrow()
        }else{
            return Option<BreakpointInfo>.None
        }
    }

    public func createAndInsert(task:DownloadTask):BreakpointInfo{
        println("kkkkkkkkkkkkk")
        let id:Int64 = task.getId()
        var newInfo:BreakpointInfo = BreakpointInfo(id,task.getUrl(),task.getParentFile(), task.getFilename().getOrThrow())
        synchronized(m){
            storedInfos.put(id, newInfo)
            unStoredTasks.remove(id)
        }
        return newInfo
    }

    public func onTaskStart(id:Int64):Unit{

    }



    public func onSyncToFilesystemSuccess(info:BreakpointInfo,blockIndex:Int64,increaseLength:Int64):Unit{
        //------

    }

    public func update(breakpointInfo:BreakpointInfo):Bool{
        let filename:Option<String> = breakpointInfo.getFilename()
        if(let Some(i) = filename){
            if(breakpointInfo.isTaskOnlyProvidedParentPath()){
                this.responseFilenameMap.put(breakpointInfo.getUrl(), i);
            }
        }

        let onCacheOne:Option<BreakpointInfo> = this.storedInfos.get(breakpointInfo.id).getOrThrow()
        if(let Some(i) = onCacheOne){
             if(refEq(i,breakpointInfo)){
                return true
             }
            //------

             return true
        }else{
             return false
        }
    }



    public func onTaskEnd(id:Int64,cause:EndCause,exception:Option<Exception>):Unit{
        //------

    }



    public func getAfterCompleted(id:Int64):Option<BreakpointInfo>{
        return Option<BreakpointInfo>.None
    }

    public func markFileDirty(id:Int64):Bool{
        if (!fileDirtyList.contains(id)){
            synchronized(m2){
                if (!fileDirtyList.contains(id)) {
                     fileDirtyList.append(id)
                     return true
                }
            }
        }
        return false
    }



    public func markFileClear(id:Int64):Bool{
        //------

        return true
    }






    public func remove(id:Int64):Unit{
        //------

    }


    public func findOrCreateId(task:DownloadTask):Int64{
        synchronized(m){
            print("44444")
            let candidate:Option<Int64> = keyToIdMap.get(task)
            if(let Some(i) = candidate){
                return i
            }
            print("55555")
            let keyList:Keys<Int64> = storedInfos.keys()
            let itera:Iterator<Int64>  = keyList.iterator()
            while(true){
               var optKey:Option<Int64> = itera.next()
               match(optKey){
                    case Some(v)=>
                       let info:Option<BreakpointInfo> =  storedInfos.get(v).getOrThrow()
                       //------

                    case None => break
               }
            }
            print("66666")
           let keyList2:Keys<Int64> = unStoredTasks.keys()
           let itera2:Iterator<Int64>  = keyList2.iterator()
           while(true){
                var optKey:Option<Int64> = itera2.next()
                match(optKey){
                    case Some(v)=>
                       let another:Option<IdentifiedTask> =  unStoredTasks.get(v).getOrThrow()
                     //------

                    case None => break
                }
           }
            print("77777")
           let id:Int64 = allocateId()
            print("id==="+id.toString())
           unStoredTasks.put(id, task.mock(id))
           keyToIdMap.add(task, id)
           return id
        }
    }


    public func findAnotherInfoFromCompare(task:DownloadTask,ignored:BreakpointInfo):Option<BreakpointInfo>{
        println("llllll6")
        let clonedMap:HashMap<Int64,Option<BreakpointInfo>>
        synchronized(m){
            clonedMap = storedInfos.clone()
        }
        let size:Int64 = clonedMap.size
        let keyList:Keys<Int64> = clonedMap.keys()
        let itera:Iterator<Int64>  = keyList.iterator()
        while(true){
            var optKey:Option<Int64> = itera.next()
            match(optKey){
                case Some(v)=>
                    let info:Option<BreakpointInfo> =  clonedMap.get(v).getOrThrow()
                    if(let Some(j) = info){
                        if(refEq(j,ignored)){
                            continue
                        }
                        //------


                    }else{
                        continue
                    }
                case None => break
            }
        }
        return  Option<BreakpointInfo>.None
    }

    //------
    public func isOnlyMemoryCache():Bool{
        return true
    }


    //------



    //------



    public static let FIRST_ID:Int64 = 1

    func allocateId():Int64{
        synchronized(m){

            var newId:Int64 = 0
            var index:Int64 = 0
            var preId:Int64 = 0
            var curId:Int64
            for(i in 0..sortedOccupiedIds.size){
                //------

            }

            if (newId == 0) {
                if (sortedOccupiedIds.isEmpty()) {
                    newId = FIRST_ID
                } else {
                    //------

                }
            }

            sortedOccupiedIds.insert(index, newId)
            return newId
        }
    }
}
