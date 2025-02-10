/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights resvered.
 */

package download4cj

public class PreError <: DownloadCache{

    init(realCause:IOException){
         super(Option<MultiPointOutputStream>.None)
         setUnknownError(realCause)
    }
}
