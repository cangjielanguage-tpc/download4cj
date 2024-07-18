/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights resvered.
 */

package download4cj

public class DownloadOkHttp3Connection <: DownloadConnection & DownloadConnectionConnected{

    let client:HttpClient
    private let requestBuilder:RequestBuilder
    private var request:Option<Request>
    var response:Option<Response>

    init(client:HttpClient,requestBuilder:RequestBuilder){
        this.client = client
        this.requestBuilder = requestBuilder
        request = Option<Request>.None
        response = Option<Response>.None
    }

    init(client:HttpClient,url:String){
        this(client,Request.builder().url(url))
    }

    public func addHeader(name:String,value:String):Unit{
        this.requestBuilder.header(name, value)
    }

    public func execute():DownloadConnectionConnected{
        request = requestBuilder.build()
        response = client.newCall(request.getOrThrow()).execute()
        return this
    }

    public func release():Unit{
        request = Option<Request>.None
        if(let Some(i) <- response){
            i.close()
        }
        response = Option<Response>.None
    }

    public func getRequestProperties():HashMap<String, ArrayList<String>>{
        var hashMapList:HashMap<String, ArrayList<String>> = HashMap<String, ArrayList<String>>()
        var header:Option<Header> = Option<Header>.None
        if(let Some(i) <- request){
             header = i.getHeaders()
        }else{
             header = requestBuilder.build().getHeaders()
        }
        var itera:Iterator<(String, ArrayList<String>)> =  header.getOrThrow().iterator()
        while(true){
            var optKey:Option<(String, ArrayList<String>)> = itera.next()
            match(optKey){
                case Some(v)=>
                    var key = v[0]
                    var value = v[1]
                    hashMapList.put(key,value)
                case None => break
            }
        }
        return hashMapList
    }



    public func getResponseCode():Int64{
        if(let Some(i) <- response){
            return i.getCode()
        }else{
            throw  ReadWriteException("Please invoke execute first!")
        }
    }


    public func getInputStream():Source{
        if(let Some(_) <- response){
        }else{
            throw  ReadWriteException("Please invoke execute first!")
        }
        let body:Option<ResponseBody> = response.getOrThrow().getBody()
        if(let Some(i) <- body){
            return i.getSource()
        }else{
            throw  ReadWriteException("no body found on response!")
        }
    }



    public func getResponseHeaderFields():Option<HashMap<String,ArrayList<String>>>{
        if(let Some(i) <- response){
            var header:Header = i.getHeaders()
            var hashMapList:HashMap<String, ArrayList<String>> = HashMap<String, ArrayList<String>>()
            var itera:Iterator<(String, ArrayList<String>)> =  header.iterator()
            while(true){
            var optKey:Option<(String, ArrayList<String>)> = itera.next()
                match(optKey){
                    case Some(v)=>
                        var key = v[0]
                        var value = v[1]
                        hashMapList.put(key,value)
                    case None =>
                        break
                }
            }
            return hashMapList
        }else{
            return Option<HashMap<String,ArrayList<String>>>.None
        }
    }


    public func getResponseHeaderField(name:String):Option<String>{
         if(let Some(i) <- response){
            if(let Some(j) <- i.getHeader(name)){
                return j
            }else{
                return Option<String>.None
            }
         }else{
            return Option<String>.None
         }
    }


    public func getRedirectLocation():Option<String>{
        let priorRes:Option<Response> = response.getOrThrow().getPrevResponse()
         if(let Some(i) <- priorRes){
            if(response.getOrThrow().isSuccess() && i.isRedirect()){
                return response.getOrThrow().getRequest().getUrl().toString()
            }
        }
        return Option<String>.None
    }
}
