package okdownload

public class KeyToIdMap{

    private let keyToIdMap:HashMap<String, Option<Int64>>
    private let idToKeyMap:HashMap<Int64,Option<String>>

    init(){
        this(HashMap<String,Option<Int64>>(),HashMap<Int64,Option<String>>())
    }

    init(keyToIdMap:HashMap<String, Option<Int64>>,idToKeyMap:HashMap<Int64,Option<String>>){
        this.keyToIdMap = keyToIdMap
        this.idToKeyMap = idToKeyMap
    }

    public func get(task:DownloadTask):Option<Int64>{
        let genKey:String = generateKey(task)
        if(let Some(i) = keyToIdMap.get(genKey)){
            return i.getOrThrow()
        }else{
            return Option<Int64>.None
        }
    }


    public func remove(id:Int64){
        //------

    }

    public func add(task:DownloadTask,id:Int64):Unit{
        let key:String = generateKey(task)
        keyToIdMap.put(key,id)
        idToKeyMap.put(id,key)
    }


    func generateKey(task:DownloadTask):String{
        if(Util.isEmpty(task.getFilename())){
            return task.getUrl()+task.getUri().toString()
        }else{
            return task.getUrl()+task.getUri().toString()+task.getFilename().getOrThrow()
        }
    }

}
