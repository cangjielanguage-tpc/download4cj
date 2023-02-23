package okdownload

public class DownloadOkHttp3ConnectionFactory <: DownloadConnectionFactory{

    let m:MultiConditionMonitor = MultiConditionMonitor()
    private var clientBuilder:Option<OkHttpClientBuilder> = Option<OkHttpClientBuilder>.None
    private var client:Option<OkHttpClient> = Option<OkHttpClient>.None


    public func create(url:String):DownloadConnection{
        if(let Some(i) = client){

        }else{
            synchronized(m){
                if(let Some(j) = client){

                }else{

                    if(let Some(k) = clientBuilder){
                        client = k.build()
                    }else{
                        client = OkHttpClient(OkHttpClient.builder())
                    }
                    clientBuilder = Option<OkHttpClientBuilder>.None

                }
            }
        }
        return DownloadOkHttp3Connection(client.getOrThrow(),url)
    }



}
