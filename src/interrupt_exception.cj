/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights resvered.
 */

package download4cj

public class InterruptException <: Exception {

    private init(){
        super("Interrupted")
    }

    static let SIGNAL:InterruptException = InterruptException()
}
