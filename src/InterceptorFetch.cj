package okdownload

public interface InterceptorFetch {

  func interceptFetch(chain:DownloadChain):Int64

}
