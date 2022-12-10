package okdownload

public class OkDownload {

    static let m:MultiConditionMonitor = MultiConditionMonitor()


    static var singleton:Option<OkDownload> = Option<OkDownload>.None
    private let downloadDispatchers:DownloadDispatcher
    private let callbackDispatchers:CallbackDispatcher
    private let breakpointStores:BreakpointStore
    private let connectionFactorys:DownloadConnectionFactory
    private let outputStreamFactorys:DownloadOutputStreamFactory
    private let processFileStrategys:ProcessFileStrategy
    private let downloadStrategys:DownloadStrategy

    var monitor:Option<DownloadMonitor>

    init(downloadDispatchers:DownloadDispatcher,callbackDispatchers:CallbackDispatcher,store:DownloadStore,
     connectionFactorys:DownloadConnectionFactory,outputStreamFactorys: DownloadOutputStreamFactory,
     processFileStrategys:ProcessFileStrategy,downloadStrategys:DownloadStrategy){
        this.downloadDispatchers = downloadDispatchers
        this.callbackDispatchers = callbackDispatchers
        this.breakpointStores = store
        this.connectionFactorys = connectionFactorys
        this.outputStreamFactorys = outputStreamFactorys
        this.processFileStrategys = processFileStrategys
        this.downloadStrategys = downloadStrategys
        this.downloadDispatchers.setDownloadStore(store)
        this.monitor = Option<DownloadMonitor>.None
    }

    public func downloadDispatcher():DownloadDispatcher{
        return downloadDispatchers
    }

    public func callbackDispatcher():CallbackDispatcher{
        return callbackDispatchers
    }

    public func breakpointStore():BreakpointStore{
        return breakpointStores
    }

    public func connectionFactory():DownloadConnectionFactory{
        return connectionFactorys
    }

    public func outputStreamFactory():DownloadOutputStreamFactory{
        return outputStreamFactorys
    }

    public func processFileStrategy():ProcessFileStrategy{
        return processFileStrategys
    }

    public func downloadStrategy():DownloadStrategy{
        return downloadStrategys
    }

    public func setMonitor(monitor:Option<DownloadMonitor>):Unit{
        this.monitor = monitor
    }

    public func getMonitor():Option<DownloadMonitor>{
        return monitor
    }


    public static func withs():OkDownload{
        if(let Some(i) = singleton){

        }else{
            //为空
            synchronized(m){
                if(let Some(i) = singleton){

                }else{
                    //为空
                    //TODO
                    //singleton = OkDownloadBuilder().build()
                }
            }

        }

        return singleton.getOrThrow()
    }


    //------

}
