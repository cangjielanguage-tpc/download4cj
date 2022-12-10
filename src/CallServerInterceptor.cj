package okdownload

public class CallServerInterceptor <: InterceptorConnect{

    public func interceptConnect(chain:DownloadChain):Option<DownloadConnectionConnected>{
        println("zzzzzzzzzz7")
         return chain.getConnectionOrCreate().execute()
    }

}
