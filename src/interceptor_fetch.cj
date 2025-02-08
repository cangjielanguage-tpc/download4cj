/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights resvered.
 */

package download4cj

public interface InterceptorFetch {

  func interceptFetch(chain:DownloadChain):Int64

}
