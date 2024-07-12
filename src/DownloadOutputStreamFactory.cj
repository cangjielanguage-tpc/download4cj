/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights resvered.
 */

package download4cj

public interface DownloadOutputStreamFactory {

    func create(file:File,flushBufferSize:Int64):DownloadOutputStream

    func create(uri:String,flushBufferSize:Int64):DownloadOutputStream

    func supportSeek():Bool

}
