//
//  WBUserAccount.swift
//  WeiBo
//
//  Created by wangjl on 2017/4/30.
//  Copyright © 2017年 avery. All rights reserved.
//

import UIKit

private let accountFile :NSString = "useraccount.json"
//用户账户名
class WBUserAccount: NSObject {
    //访问令牌
    var access_token : String? //= "2.00v_BMCDKohrnDd305f9aca2PRPm_C"
    //用户代号
    var uid : String?
    // 开发者5年 每次登录之后 ，重新算5年
    // 使用者3天，会从第一次登录之后递减
    var expires_in : TimeInterval = 0 {
        
        didSet{
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    //过期日期
    var expiresDate : Date?
    
    //用户昵称
    var screen_name : String?
    //用户头像地址（大图），180×180像素
    var avatar_large : String?
    
    override var description: String{
        return yy_modelDescription()
    }
    
    
    override init() {
        super.init()
          // NsData -字典-model
        //从磁盘加载保存的文件
        
        //加载磁盘文件二进制数据，如果失败直接返回
        guard  let path=accountFile.cz_appendDocumentDir()
            ,let data = NSData(contentsOfFile: path),
        let dic = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String:AnyObject]
            else{
                return
        }
        // 使用字典设置属性值
        //用户是否登录关键
        yy_modelSet(with: dic ?? [:])
//        expiresDate = Date(timeIntervalSinceNow: -3600 * 24)
        //判断token是否过期
        if expiresDate?.compare(Date()) != .orderedDescending{
            print("账户过期")
            //清空token
            access_token = nil
            uid = nil
            
            //删除账户文件
         _ = try? FileManager.default.removeItem(atPath: path)
            return
        }
        
        print("账户正常")
        
        
    }
    
    /*
     1 偏好设置（小）Xcode 8 beta 无效！
     2 沙盒-归档/plist /json
     3 数据库(FMDB/CoreData)
     4 钥匙串访问（小/自动加密 - 需要使用框架SSKeychain）
     
     */
    func  saveAccount() {
        
        // model-字典-NSData-保存
        
        // 1 模型转字典
        var dic = (self.yy_modelToJSONObject() as? [String:AnyObject]) ?? [:]
        //  需要删除expires_in
        dic.removeValue(forKey: "expires_in")
        
        // 2 字典序列化 data
        
        guard let data = try? JSONSerialization.data(withJSONObject: dic, options: []),
            let filePath=accountFile.cz_appendDocumentDir()
            else{
                return
        }
        
        // 3 写磁盘
        (data as NSData).write(toFile: filePath, atomically: true)
        
        print("保存成功\(filePath)")
        
        
    }
}
