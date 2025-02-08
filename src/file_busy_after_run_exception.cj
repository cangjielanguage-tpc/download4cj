/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights resvered.
 */

package download4cj

public class FileBusyAfterRunException <: Exception {

    private init(){
        super("File busy after run")
    }

    static let SIGNAL:FileBusyAfterRunException = FileBusyAfterRunException()
}
