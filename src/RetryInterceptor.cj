package okdownload

public class RetryInterceptor <: InterceptorConnect & InterceptorFetch{


    public func interceptConnect(chain:DownloadChain):Option<DownloadConnectionConnected>{

        let cache:DownloadCache =  chain.getCache()
        while(true){
            try{
                if(cache.isInterrupt()){
                     //----
                     //throw InterruptException.SIGNAL
                     //----
                }
                println("下载开始了003      blockIndex==="+chain.getBlockIndex().toString())
                return chain.processConnect()
            }catch (e:IOException) {
                //------

                throw e
            }
        }
        return Option<DownloadConnectionConnected>.None
    }



    public func interceptFetch(chain:DownloadChain):Int64{
        try {
            println("下载开始了009     blockIndex==="+chain.getBlockIndex().toString())
            return chain.processFetch()
        } catch (e:IOException) {
            //------

            throw e
        }
    }





}
