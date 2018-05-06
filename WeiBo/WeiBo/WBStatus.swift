//
//  WBStatus.swift
//  WeiBo
//
//  Created by avery on 17/4/22.
//  Copyright © 2017年 avery. All rights reserved.
//

import UIKit
import YYModel

//微博数据模型
class WBStatus: NSObject {
    //Int 类型，在64位的机器是64位，在32位机器就是32位
    //如果不写Int64在ipad2/iPhone5/5c/4s/4 都无法正常运行，数据会溢出
    var id: Int64 = 0;
    //微博消息内容
    var text: String?
    
    //重写description的计算型属性
    override var description: String{
        return yy_modelDescription()
    }
}
