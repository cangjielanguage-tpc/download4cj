/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights resvered.
 */

package download4cj

public interface DownloadConnection {

    func addHeader(name:String,value:String):Unit

    func execute():DownloadConnectionConnected

    func release():Unit

    func getRequestProperties():HashMap<String,ArrayList<String>>

}
