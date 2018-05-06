//
//  WeiBoCommon.swift
//  WeiBo
//
//  Created by wangjl on 2017/4/29.
//  Copyright © 2017年 avery. All rights reserved.
//

import Foundation


//MARK:-应用程序信息

//应用程序ID
let WBAppkey="3485238746"
//应用程序加密信息（开发者可以申请修改）
let WBAppSecret="32cb3a76c17f906824da1a47dc108fc7"
//回调地址 - 登录完成后调转的URL,参数以get形式拼接
let WBRedirectURI="https://www.baidu.com"

//MARK:-全局通知定义
//用户登录通知
let WBUserShouldLoginNotification = "WBUserShouldLoginNotification"
//用户登录成功通知
let WBUserLoginSuccessNotification = "WBUserLoginSuccessNotification"
