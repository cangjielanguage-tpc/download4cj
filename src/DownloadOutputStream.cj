/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights resvered.
 */

package download4cj

public interface DownloadOutputStream {

    func write(b:Array<UInt8>):Unit

    func close():Unit

    func flushAndSync():Unit

    func seek(offset:Int64):Unit

    func setLength(newLength:Int64):Unit

}
