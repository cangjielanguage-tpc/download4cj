/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights resvered.
 */

package download4cj

public class ResumeFailedException <: Exception{

    private let resumeFailedCause:ResumeFailedCause


     init(cause:ResumeFailedCause){
        this.resumeFailedCause = cause
    }

}
