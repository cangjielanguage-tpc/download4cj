package okdownload

public interface InterceptorConnect {

   func interceptConnect(chain:DownloadChain):Option<DownloadConnectionConnected>

}
