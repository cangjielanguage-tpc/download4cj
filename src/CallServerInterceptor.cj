/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights resvered.
 */

package download4cj

public class CallServerInterceptor <: InterceptorConnect{

    public func interceptConnect(chain:DownloadChain):Option<DownloadConnectionConnected>{
         return chain.getConnectionOrCreate().execute()
    }

}
