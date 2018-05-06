
//
//  Bundle+Extention.swift
//  反射机制
//
//  Created by avery on 17/1/4.
//  Copyright © 2017年 avery. All rights reserved.
//

import Foundation

extension Bundle{
    func nameSpace() -> String {
        
//        return Bundle.main.infoDictionary?["CfBoundName"] as? String ?? ""
        var str:String=infoDictionary?["CFBundleName"] as? String ?? ""

        return str;
        
        
    }
    
    
    //计算型属性类似于函数 没有参数 有返回值 //不占用
    var nameSpacses:String{
        return infoDictionary?["CfBoundName"] as? String ?? ""

    }
}
