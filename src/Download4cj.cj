package download4cj

public class Download4cj {

    static let m:MultiConditionMonitor = MultiConditionMonitor()


    static var singleton:Option<Download4cj> = Option<Download4cj>.None
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

     func downloadDispatcher():DownloadDispatcher{
        return downloadDispatchers
    }

     func callbackDispatcher():CallbackDispatcher{
        return callbackDispatchers
    }

     func breakpointStore():BreakpointStore{
        return breakpointStores
    }

     func connectionFactory():DownloadConnectionFactory{
        return connectionFactorys
    }

     func outputStreamFactory():DownloadOutputStreamFactory{
        return outputStreamFactorys
    }

     func processFileStrategy():ProcessFileStrategy{
        return processFileStrategys
    }

     func downloadStrategy():DownloadStrategy{
        return downloadStrategys
    }

     func setMonitor(monitor:Option<DownloadMonitor>):Unit{
        this.monitor = monitor
    }



     static func withs():Download4cj{
        if(let Some(_) <- singleton){
        }else{
            synchronized(m){
                if(let Some(_) <- singleton){
                }else{
                    //为空
                    singleton = Download4cjBuilder().build()
                }
            }
        }
        return singleton.getOrThrow()
    }

}
