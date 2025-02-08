/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights resvered.
 */

package download4cj

public class PreAllocateException <: Exception {

 private let requireSpace:Int64
 private let freeSpace:Int64



    init(requireSpace:Int64,freeSpace:Int64){
    super("There is Free space less than Require space: " + freeSpace.toString() + " < " + requireSpace.toString())
    this.requireSpace = requireSpace
    this.freeSpace = freeSpace
   }


}
