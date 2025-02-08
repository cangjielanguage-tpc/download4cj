/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights resvered.
 */

package download4cj

public class FileNameHolder{

    private var filename:Option<String>
    private let filenameProvidedByConstruct:Bool

     init(){
        this.filename = Option<String>.None
        this.filenameProvidedByConstruct = false
    }

     init(filename:String){
        this.filename = filename
        this.filenameProvidedByConstruct = true
    }



     func get():Option<String>{
        return filename
    }

}
