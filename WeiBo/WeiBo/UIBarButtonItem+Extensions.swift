//
//  UIBarButtonItem+Extensions.swift
//  WeiBo
//
//  Created by wangjl on 2017/1/8.
//  Copyright © 2017年 avery. All rights reserved.
//

import UIKit
extension UIBarButtonItem{
    
    //convenience 便利构造函数  command+opition +/ 注释快捷键
    /// 创建UIBarButtonItem
    ///
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - fontSize: 默认16号
    ///   - target:
    ///   - action: <#action description#>
    convenience init(title:String,fontSize:CGFloat=16,target:AnyObject,action:Selector, isBack: Bool = false) {
        
        let btn: UIButton = UIButton.cz_textButton(title, fontSize: fontSize, normalColor: UIColor.gray, highlightedColor: UIColor.orange)
        
        if(isBack) {
            let imageName = "navigationbar_back_withtext"
            btn.setImage(UIImage(named: imageName), for: .normal)
            btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
            btn.sizeToFit()
        }
        
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        self.init(customView:btn)
        
    }
}

//无法满足点击高亮的效果
//        navigationItem.leftBarButtonItem=UIBarButtonItem(title: "好友", style: .plain, target: self, action:#selector(showFriend))
//        let leftBtn=UIButton()
//        leftBtn.setTitle("首页", for: UIControlState(rawValue: 0))
//        leftBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
//        leftBtn.setTitleColor(UIColor.red, for:UIControlState.highlighted)
//        leftBtn.addTarget(self, action:#selector(showFriend), for: .touchUpInside)
//        leftBtn.sizeToFit()
//        navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftBtn)
//        navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftBWtn)
//        navigationItem.leftBarButtonItem=UIBarButtonItem(title: "好友", target: self, action: #selector(showFriend))
