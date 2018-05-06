//
//  AppDelegate.swift
//  WeiBo
//
//  Created by avery on 17/1/5.
//  Copyright © 2017年 avery. All rights reserved.
//

import UIKit
import UserNotifications
import SVProgressHUD
import AFNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupAddtions()
       
        
        window=UIWindow()
        window?.backgroundColor=UIColor.white
        window?.rootViewController=WBMainViewController()
        window?.makeKeyAndVisible()
        return true
        
    }
    
}

//MARK:  设置应用程序额外信息
extension AppDelegate{
    
    fileprivate func setupAddtions(){
        
        // 1 设置SVRrogeressHUD 最小解除时间
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        
        //2 设置加载网络加载指示器
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        
        //3 设置用户权限通知
        //#available 只监测设备版本，如果是10.0以上
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.carPlay,.badge,.sound]) { (success, error) in
                print("授权"+(success ? "成功":"失败"))
            }
        } else {
            //10.0 以下
            //取得用户授权显示通知（上方的提示条/声音/BadgeNumber）
            let notifiSetting=UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notifiSetting)
            
        }
        
    }
}

// MARK: - 从服务器加载加载应用程序信息
extension AppDelegate{
    //1模拟异步
    private func loadAppInfo(){
        //        1
        DispatchQueue.global().async {
            
            //            1 url
            let url=Bundle.main.url(forResource: "main.json", withExtension: nil)
            
            //2 data
            let data=NSData(contentsOf: url!)
            //3 写入磁盘
            let docDir=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let jsonPath=(docDir as NSString).appendingPathComponent("main.json")
            //直接保存在沙盒，等待下一次启动使用
            data?.write(toFile: jsonPath, atomically: true)
            
            print("应用程序加载完毕\(jsonPath)")
            
        }
        
    }
}
