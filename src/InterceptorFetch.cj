package download4cj

public interface InterceptorFetch {

  func interceptFetch(chain:DownloadChain):Int64

}
