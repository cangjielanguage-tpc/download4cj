


from std import fs.*
from std import io.*
from std import runtime.*



main(){
    ///home/hhs/ok-download/ci_test/test_temp/run/maintest09_cj_1675241733_3725836/download/100M.txt
    var fsIn: File = File("/home/hhs/ok-download/1G.txt", OpenOption.Open(true,false))
    var fsOut: File = File("/home/hhs/ok-download/TO1G.txt", OpenOption.Create(false))
    try{



        let input = BufferedInputStream(fsIn,4096)
        let output = BufferedOutputStream(fsOut,4096)

        var buffer = Array<Byte>(4096,{i => 0})

        while(true){
            let len = input.read(buffer)
            if(len > 0){
                output.write(buffer.slice(0,len))
                println("maxHeapSize="+MemoryInfo.maxHeapSize.toString()+"-------allocatedHeapSize="+MemoryInfo.allocatedHeapSize.toString()+"------heapPhysicalMemory="+MemoryInfo.heapPhysicalMemory.toString())
                output.flush()
            }else{
                break
            }
        }

    }finally{
        fsIn.close()
        fsOut.close()
    }

}


