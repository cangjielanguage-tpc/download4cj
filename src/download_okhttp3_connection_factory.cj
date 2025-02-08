/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights resvered.
 */

package download4cj

public class DownloadOkHttp3ConnectionFactory <: DownloadConnectionFactory{

    let m:MultiConditionMonitor = MultiConditionMonitor()
    private var clientBuilder:Option<HttpClientBuilder> = Option<HttpClientBuilder>.None
    private var client:Option<HttpClient> = Option<HttpClient>.None


    public func create(url:String):DownloadConnection{
        if(let Some(_) <- client){

        }else{
            synchronized(m){
                if(let Some(_) <- client){
                }else{
                    if(let Some(k) <- clientBuilder){
                        client = k.build()
                    }else{
                        let a = HttpClient.builder()
                        a.connectionPool(ConnectionPool(maxIdleConnections:500))
                        a.readTimeout(Duration.hour*1)
                        a.connectTimeout(Duration.hour*1)
                        a.retryOnConnectionFailure(true)
                        client = HttpClient(a)
                    }
                    clientBuilder = Option<HttpClientBuilder>.None
                }
            }
        }
        return DownloadOkHttp3Connection(client.getOrThrow(),url)
    }



}
