//
//  DEMOViewController.swift
//  WeiBo
//
//  Created by wangjl on 2017/1/8.
//  Copyright © 2017年 avery. All rights reserved.
//

import UIKit

class DEMOViewController: WBBaseViewController {

    override func viewDidLoad() {
    
        super.viewDidLoad()
        //设置标题
//        title="第\(navigationController?.childViewControllers.count)个"
        title="第\(navigationController?.childViewControllers.count ?? 0)个"
        
    }
    
    func nextStep(){
          let vc=DEMOViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
extension DEMOViewController{
    override func setupTableView() {
        super.setupTableView()
        //页面跳转卡可能是因为未设置背景颜色
        //设置右侧控制器
        //        navigationItem.rightBarButtonItem=UIBarButtonItem(title: "下一个", style: .plain, target: self, action: #selector(nextStep))
        //        navigationItem.rightBarButtonItem=UIBarButtonItem(title: "下一个", target: self, action: #selector(nextStep))
        navItem.rightBarButtonItem=UIBarButtonItem(title: "下一个", fontSize: 16, target: self, action: #selector(nextStep))

    }
  }
