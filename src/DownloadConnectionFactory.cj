/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights resvered.
 */

package download4cj

public interface DownloadConnectionFactory {

    func create(url:String):DownloadConnection

}
