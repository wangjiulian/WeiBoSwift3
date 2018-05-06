//
//  WBNavigationController+Extension.swift
//  WeiBo
//
//  Created by avery on 17/4/21.
//  Copyright © 2017年 avery. All rights reserved.
//

import Foundation

extension WBNetworkManager{
    
    /// 加载微博数据字典数组
    ///
    /// - Parameters:
    ///   - completion: 完成回调（list:微博数组／是否成功）
    ///   - isSuccess: isSuccess description
    ///   - since_id: 返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
    ///   - max_id: 返回ID小于或大于 max_id的微博，默认为0
    ///   - completion:
    func statusList(since_id:Int64=0,max_id:Int64=0,completion:@escaping (_ list:[[String:AnyObject]]?,_ isSuccess:Bool)->()) {
        let urlString="https://api.weibo.com/2/statuses/home_timeline.json";
        //         let params=["access_token":"2.00v_BMCDSZSTDCff6e0e3dfbZgCAZC"]
        //Swift中Int可以转换成AnyObject/但是Int64不行
        // max_id去比max_id小的才能不会重复
        let params=["since_id":"\(since_id)","max_id":"\(max_id>0 ? max_id-1 : 0)"]
        tokenRequest(URLString: urlString, parameters: params as [String:AnyObject]) { (json:Any?, isSuccess:Bool) in
            //            print(json)
            let jsonStr=json as? AnyObject;
            //从json中获取
            let result = jsonStr?["statuses"] as? [[String:AnyObject]]
            completion(result,isSuccess)
            
        }
        
    }
    
    
    
    /// 返回未读数量
    ///
    /// - Parameter completion: <#completion description#>
    func unreadCount(completion:@escaping (_ count:Int)->()) {
        
        guard let uid = userAccount.uid else {
            return
        }
        let urlString="https://rm.api.weibo.com/2/remind/unread_count.json"
        
        let params=["uid":uid]
        
        tokenRequest(URLString: urlString, parameters: params as [String:AnyObject] ) { (json, isSuccess) in
            
            let dic=json as? [String:String]
            let count = dic?["status"] as? Int
            completion(count ?? 0)
            
            
            
        }
        
    }
    
}

//MARK - 用户信息
extension WBNetworkManager{
    //加载当前用户信息 用户登录后立即执行
    func loadUserInfo(completion:@escaping (_ dict:[String:AnyObject])->())  {
        
        guard let uid=userAccount.uid else {
            return
        }
        let urlString = "https://api.weibo.com/2/users/show.json"
        let params = ["uid":uid]
        tokenRequest(URLString: urlString, parameters: params as [String:AnyObject]) { (json, isSuccess) in
            completion(json as? [String:AnyObject] ?? [:])
        }
        
    }
    
}


//MARK - OAuthor相关
extension WBNetworkManager{
    
    //加载accessToken
    
    ///
    /// - Parameters:
    ///   - code: 授权码
    ///   - completion: 完成回调
    func loadAccessToken(code:String,completion:@escaping (_ isSuccess:Bool)->())  {
        let urlString="https://api.weibo.com/oauth2/access_token"
        let params=["client_id":WBAppkey,
                    "client_secret":WBAppSecret,
                    "grant_type":
            "authorization_code",
                    "code":code,
                    "redirect_uri":WBRedirectURI]
        
        request(method: WBHTTPMethod.POST, URLString: urlString, parameters: params as [String:AnyObject]) { (json, isSuccess) in
            
            //如果请求失败，对用户账户数据不会有影响
            // 直接用字典设置userAccount的属性
            self.userAccount.yy_modelSet(with: json as? [String : AnyObject] ?? [:])
            print(self.userAccount)
                       //加载当前用户信息
            self.loadUserInfo(completion: { (dict) in
                print(dict)
                
                //使用用户信息字典设置用户账户信息（昵称和头像地址）
                self.userAccount.yy_modelSet(with: dict)
                //用户信息加载完成再完成回调 完成回调
                //保存模型
                self.userAccount.saveAccount()
                
                completion(isSuccess)
            })
        
        }
        
    }
}


