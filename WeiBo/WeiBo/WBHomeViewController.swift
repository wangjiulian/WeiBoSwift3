//
//  WBHomeViewController.swift
//  WeiBo
//
//  Created by avery on 17/1/5.
//  Copyright © 2017年 avery. All rights reserved.
//

import UIKit

//定义全局常量，尽量使用prite 否则哪里都可以用到
private let cellId="cellId"


class WBHomeViewController: WBBaseViewController {
    
    //懒加载
    //    var statusList=[String]()
    //列表视图模型
    lazy var listViewModel=WBStatusListViewModel()
    
    //加载数据
    override func loadData() {
        //用网络工具加载微博数据
        
        listViewModel.loadData(ispullUp: self.isPullup) { (isSuccess) in
            
            if(isSuccess){
                //结束刷新控件
                self.refreshControl?.endRefreshing()
                //恢复上拉标志
                self.isPullup=false
                print("刷新表格")
                self.tableView?.reloadData()
            }
            
        }
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //显示好友
    func showFriend(){
        let vc=DEMOViewController()
        vc.hidesBottomBarWhenPushed=true;
        //PUSH 的动作时nav做的
        //WBNavigationController=self.navigationController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - 表格数据源方法 具体的数据源方法，不需要super
extension WBHomeViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //1 取cell
        let cell=tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WBStatusCell
        //2 设置cell
        cell.statusLabel.text=listViewModel.statusList[indexPath.row].text;
        //3 返回cell
        return cell
        
    }
    
    
}

//MARK: 设置界面
extension WBHomeViewController{
    //重写父类方法
    
    override func setupTableView() {
        super.setupTableView()
        //设置导航栏按钮
        navItem.leftBarButtonItem=UIBarButtonItem(title: "好友", fontSize: 16, target: self, action: #selector(showFriend))
        
        //注册原型 cell
        //        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        tableView?.register(UINib(nibName: "WBStatusNormalCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        //设置行高
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300 //默认300
        
        //取消分割线
        tableView?.separatorStyle = .none
        
        setUpNavTitle()
    }
    
    
    /// 设置导航栏标题
    private func setUpNavTitle(){
        let title = WBNetworkManager.shared.userAccount.screen_name
        let button = WBTitleButton(title: title!)
        navItem.titleView = button
        
        button.addTarget(self, action: #selector(clickTitleButton), for: .touchUpOutside)
        
    }
    
    @objc func clickTitleButton(btn:UIButton){
        
        //设置选中状态
        btn.isSelected = !btn.isSelected
    }
    
    
}
