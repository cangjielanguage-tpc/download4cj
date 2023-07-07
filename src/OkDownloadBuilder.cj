package okdownload

public class OkDownloadBuilder {

    private var downloadDispatchers:Option<DownloadDispatcher>
    private var callbackDispatchers:Option<CallbackDispatcher>
    private var downloadStores:Option<DownloadStore>
    private var connectionFactorys:Option<DownloadConnectionFactory>
    private var processFileStrategys:Option<ProcessFileStrategy>
    private var downloadStrategys:Option<DownloadStrategy>
    private var outputStreamFactorys:Option<DownloadOutputStreamFactory>
    private var monitors:Option<DownloadMonitor>


     init(){
        this.downloadDispatchers = Option<DownloadDispatcher>.None
        this.callbackDispatchers = Option<CallbackDispatcher>.None
        this.downloadStores = Option<DownloadStore>.None
        this.connectionFactorys = Option<DownloadConnectionFactory>.None
        this.processFileStrategys = Option<ProcessFileStrategy>.None
        this.downloadStrategys = Option<DownloadStrategy>.None
        this.outputStreamFactorys = Option<DownloadOutputStreamFactory>.None
        this.monitors = Option<DownloadMonitor>.None
    }



     func build():OkDownload{

         if(let Some(_) = downloadDispatchers){

         }else{
            downloadDispatchers = DownloadDispatcher()
         }

         if(let Some(_) = callbackDispatchers){

         }else{
            callbackDispatchers = CallbackDispatcher()
         }

         if(let Some(_) = downloadStores){

         }else{
            downloadStores =  BreakpointStoreOnCache()
         }

         if(let Some(_) = connectionFactorys){

         }else{
            connectionFactorys = DownloadOkHttp3ConnectionFactory()
         }

        if(let Some(_) = outputStreamFactorys){

         }else{
             outputStreamFactorys =  DownloadUriOutputStreamFactory()
         }

         if(let Some(_) = processFileStrategys){

         }else{
            processFileStrategys =  ProcessFileStrategy()
         }

         if(let Some(_) = downloadStrategys){

         }else{
            downloadStrategys =  DownloadStrategy()
         }

         var okDownload:OkDownload = OkDownload(downloadDispatchers.getOrThrow(),callbackDispatchers.getOrThrow(),downloadStores.getOrThrow(),connectionFactorys.getOrThrow(),outputStreamFactorys.getOrThrow(),processFileStrategys.getOrThrow(),downloadStrategys.getOrThrow())
         okDownload.setMonitor(monitors)
         return okDownload
    }
}
