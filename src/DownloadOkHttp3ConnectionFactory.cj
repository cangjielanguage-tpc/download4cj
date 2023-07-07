package okdownload

public class DownloadOkHttp3ConnectionFactory <: DownloadConnectionFactory{

    let m:MultiConditionMonitor = MultiConditionMonitor()
    private var clientBuilder:Option<OkHttpClientBuilder> = Option<OkHttpClientBuilder>.None
    private var client:Option<OkHttpClient> = Option<OkHttpClient>.None


    public func create(url:String):DownloadConnection{
        if(let Some(_) = client){

        }else{
            synchronized(m){
                if(let Some(_) = client){
                }else{
                    if(let Some(k) = clientBuilder){
                        client = k.build()
                    }else{
                        let a = OkHttpClient.builder()
                        a.connectionPool(ConnectionPool(maxIdleConnections:500))
                        a.readTimeout(Duration.hour*1)
                        a.connectTimeout(Duration.hour*1)
                        a.retryOnConnectionFailure(true)
                        client = OkHttpClient(a)
                    }
                    clientBuilder = Option<OkHttpClientBuilder>.None
                }
            }
        }
        return DownloadOkHttp3Connection(client.getOrThrow(),url)
    }



}
