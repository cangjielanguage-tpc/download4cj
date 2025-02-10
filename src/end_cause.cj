/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights resvered.
 */

package download4cj

public enum EndCause {
    | COMPLETED
    | ERROR
    | CANCELED
    | FILE_BUSY
    | SAME_TASK_BUSY
    | PRE_ALLOCATE_FAILED
}
