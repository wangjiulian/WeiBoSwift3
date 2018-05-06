//
//  WBNetworkManager.swift
//  WeiBo
//
//  Created by wangjl on 2017/4/20.
//  Copyright © 2017年 avery. All rights reserved.
//

import UIKit
//导入框架的文件名就行
import AFNetworking

enum WBHTTPMethod{
    case GET
    case POST
}

/// 网络管理工具
class WBNetworkManager: AFHTTPSessionManager {
    
    lazy var userAccount = WBUserAccount()
    
    //用户标记[计算型属性]
    var userLogon:Bool{
        return userAccount.access_token != nil
    }
    
    //专门负责拼接token的网络请求方法
    func tokenRequest(method:WBHTTPMethod = .GET, URLString:String,parameters:[String:AnyObject],completion:@escaping (_ json:Any?,_ isSuccess:Bool)->()) {
        
        //处理token字典
        //0 判断token是否为空 是否为nil 直接返回,程序执行过程中，一般Token不会为nil
        guard let token = userAccount.access_token else {
            print("没有token! 需要登录")
            completion(nil,false)
            //FIXME:发送通知，谁接收通知，谁处理
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
            return
        }
        // 1 判断参数是否存在 如果为nil,应该新建个字典
        var parameters=parameters;
        if parameters==nil {
            parameters=[String:AnyObject]()
        }
        //代码在此处一定有值
        //设置字典数据
        parameters["access_token"]=userAccount.access_token as AnyObject?;
        
        //调用request发起真正的网络请求
        request(method: method, URLString: URLString, parameters: parameters, completion: completion)
    }
    
    //静态区/常量/闭包
    // 在第一次访问时，执行闭包，并且将结果保存在shared常量中
    //    static let shared=WBNetworkManager()
    
    static let shared : WBNetworkManager = {
        //实例化对象
        let instance = WBNetworkManager()
        
        //设置响应序列化支持的数据类型
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        //返回对象
        return instance
        
    }()
    //使用一个函数封装AFN 的GET/POST
    ///
    ///
    /// - Parameters:
    ///   - method: GET\POST
    ///   - URLString: URLString
    ///   - parameters: 参数子弹
    ///   - completion: 完成回调(json/数组)，是否成功
    func request(method:WBHTTPMethod = .GET, URLString:String,parameters:[String:AnyObject],completion:@escaping (_ json:Any?,_ isSuccess:Bool)->()) {
        //
        //成功回调
        let success={ (task:URLSessionDataTask,json:Any?)->() in
            completion(json,true)
        }
        //失败回调
        let failure={ (task:URLSessionDataTask?,error:Error)->() in
            print("网络请求错误\(error)")
            if(task?.response as? HTTPURLResponse)?.statusCode == 403{
                print("token过期了")
                //FIXME:发送通知，谁接收通知，谁处理
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: "badtoken")
            }
            completion(nil, false)
        }
        if method == .GET {
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
            
        }else{
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
        
        
    }
    
}
