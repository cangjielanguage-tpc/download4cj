package download4cj

public interface InterceptorConnect {

   func interceptConnect(chain:DownloadChain):Option<DownloadConnectionConnected>

}
