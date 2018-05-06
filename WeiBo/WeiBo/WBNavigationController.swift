//
//  WBNavigationController.swift
//  WeiBo
//
//  Created by avery on 17/1/5.
//  Copyright © 2017年 avery. All rights reserved.
// d

import UIKit

// 隐藏默认bar  
// 1 当不是栈底控制器 隐藏底部的bar,修改返回按钮
class WBNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //隐藏默认的NavigationBar
        navigationBar.isHidden=true
    }
    
    //重写push方法，所有push都会调用此方法
    //viewController 是被push的控制器，设置他左侧的按钮作为返回按钮
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
      
       //如果不是栈底控制器才需要隐藏，根控制器不需要
        //WBMainViewController 加载完事childViewControllers.count＝0（包括在基础上加入首页，消息，发现，＋，我的）
        print(childViewControllers.count)
               if(childViewControllers.count>0){
            //隐藏底部的 TabBar
            viewController.hidesBottomBarWhenPushed=true
                
                //判断控制器类型
                if let vc=viewController as? WBBaseViewController {
                    var title="返回"
                    
                    //判断控制器级数，只有一个子控制器的时候，显示栈底控制器的标题
                    if childViewControllers.count==1{
                        //显示首页标题
                        title=childViewControllers.first?.title ?? "返回"
                    
                    }
                    
                    //取出自定义navbaritem
                    vc.navItem.leftBarButtonItem=UIBarButtonItem(title: title,target: self, action: #selector(popToParemt))
                }

        }
        
            super.pushViewController(viewController, animated: animated)
        
    }
    @objc private func popToParemt(){
        
        popViewController(animated: true)
    }
}
