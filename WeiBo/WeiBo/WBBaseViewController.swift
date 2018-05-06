//
//  WBBaseViewController.swift
//  WeiBo
//
//  Created by avery on 17/1/5.
//  Copyright © 2017年 avery. All rights reserved.
//

import UIKit
import SVProgressHUD



//1 所有控制器的基类
//2 设置新的导航条——NavItem
//3 重写title  可以保证外部设置title的代码需要任何设置
//4 设置表格
//5 刷新逻辑 上拉／下拉
//6 访客视图

//面试题，OC支持多继承，如果不支持，如何替代？答案：使用协议替代！
//swfit的写法更类似于多继承


/// 所有主控制器的基础
// swift中使用extension 可以把函数按照功能分类，便于阅读与维护
// 注意
// 1 extension 中不能有属性
// 2 extension 中不能重写父类方法，是子类的职责，扩展是对类的扩展
//class WBBaseViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
class WBBaseViewController: UIViewController{
    
    //用户登陆标志
    //    var userLogon=true
    //访客视图
    var visitorInfoDic:[String:String]?
    //表格视图 未登录不加载
    var tableView:UITableView?
    //刷新控件
    var refreshControl:UIRefreshControl?
    
    var isPullup=false
    //自定义导航条
    lazy var navigationBar=UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.cz_screenWidth(), height: 64))
    //自定义的导航条目 －以后设置导航栏内容使用navItem 不用UINavigationItem
    lazy var navItem=UINavigationItem()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        WBNetworkManager.shared.userLogon ? loadData():()
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: WBUserLoginSuccessNotification), object: nil)
    }
    
    deinit {
        //注册通知
        NotificationCenter.default.removeObserver(self)
    }
    //加载数据－具体的实现由子类负责
    func loadData(){
        //如果子类不实现任何方法 默认关闭
        refreshControl?.endRefreshing()
        
    }
    
    
    
    /// 重写title的setter
    override var title: String?{
        //didSet 重写set方法
        didSet{
            navItem.title=title
        }
    }
    
    
}



//MARK: 设置界面
extension WBBaseViewController{
    
    fileprivate func setUpUI(){
        view.backgroundColor=UIColor.white
        setubNavigataionBar()
        WBNetworkManager.shared.userLogon ? setupTableView():setVisitorView()
    }
    
    private func setVisitorView(){
        let visitorView=WBVisitorView(frame: view.bounds)
        visitorView.visitorInfo=visitorInfoDic;
        visitorView.loginButton.addTarget(self, action: #selector(loginDo), for: .touchUpInside)
        visitorView.registerButton.addTarget(self, action: #selector(registerDo), for: .touchUpInside)
        view.insertSubview(visitorView, belowSubview: navigationBar)
        
        //设置导航栏按钮
        navItem.leftBarButtonItem=UIBarButtonItem(title: "注册", fontSize: 16, target: self, action:#selector(registerDo) )
        navItem.rightBarButtonItem=UIBarButtonItem(title: "登录", fontSize: 16, target: self, action: #selector(loginDo) )
        
        
    }
    
    //设置表格视图
    // 子类重写此方法，因为子类不需要关心用户登录之前的逻辑
    func setupTableView(){
        
        tableView=UITableView(frame: view.bounds, style: .plain)
        //        view.addSubview(tableView!) 会把navigationBar遮住
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        //设置数据源和代理
        tableView?.dataSource=self
        tableView?.delegate=self
        
        //修改指示器的缩进 - 强行解包为了拿到一个必要的inset
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        
        //设置刷新控件
        // 1实例话控件
        refreshControl=UIRefreshControl()
        //2 添加到tablview
        tableView?.addSubview(refreshControl!)
        
        //添加监听方法 调用子类loadData方法
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        //取消自动缩进－如果隐藏了导航栏，会缩进20个点
        automaticallyAdjustsScrollViewInsets=false
        //设置内容缩进 顶部缩navigationBar的高度，底部缩tabBarController的高度，解决顶部，底部tableview显示不全
        tableView?.contentInset=UIEdgeInsets(top: navigationBar.bounds.height, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0)
        
        
    }
    
    private func setubNavigataionBar(){
        //添加导航条
        view.addSubview(navigationBar)
        //将navItem设置给navigationBar
        navigationBar.items=[navItem]
        //设navBar的渲染颜色
        navigationBar.barTintColor=UIColor.cz_color(withHex: 0xf6f6f6)
        //设置navBar字体颜色
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.red]
        //设置系统按钮文字渲染颜色
        navigationBar.tintColor=UIColor.orange
        
    }
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension WBBaseViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    //基类只是准备，子类负责实现
    //子类的数据源方法不需要super
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //只是保证没有错误
        return UITableViewCell()
    }
    //在显示最后一行 上拉刷新
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 1 判断indexPath是否最后一行，indexPath.row 最后一行
        //indexPath.section最多
        let row=indexPath.row
        //2 selection
        let selection=tableView.numberOfSections-1
        if row<0||selection<0 {
            return
        }
        //3 总行数
        let count=tableView.numberOfRows(inSection: selection)
        if row==(count-1) && !isPullup {
            
            isPullup=true
            //开始刷新
            loadData()
            return
        }
        
    }
    
    
    
    func eceptionCatche() {
        
        /// <#Description#>
        //        let jsonString="{\"name\":\"zhang\"}"
        //        let data=jsonString.data(using: .utf8)
        //反序列化 throw抛出异常
        //方法一：推荐 try? 如果解析成功，就有值，否则,为nil
        //        let json = try? JSONSerialization.jsonObject(with: data!, options: [])
        //方法二:强烈不推荐try!,如果解析成功，就有值，否则奔溃，有风险
        //        let json2=try! JSONSerialization.jsonObject(with: data!, options: [])
        //        方法三:处理
        //但是：语法结构复杂，而且，{}里面的智能提示很不友好
        //扩展：OC中有人用try catch吗 为什么
        // ARC 开个，编译器自动添加retain/relesae/autorelease\
        // 如果用try catch 一旦不平衡，就会出现内存泄露
        //        do{
        //            let json3 = try JSONSerialization.jsonObject(with: data!, options: [])
        //        }catch{
        //            print(error)
        //        }
    }
}
// MARK - 访客视图监听方法
extension WBBaseViewController{
    
    /// 登录成功处理
    @objc  fileprivate func loginSuccess(){
        
        //登录前左边是注册，右边是登录
        navItem.leftBarButtonItem = nil
        navItem.rightBarButtonItem = nil
        
        //更新UI 将访客视图 设置为表格视图
        //重新设置UI
        // 在访问 view的getter时，如果view == nil 会调用viewDidload
        view = nil
        
        //注销通知 -》重新执行 viewDidLoad会再次注册！避免通知重复注册
        NotificationCenter.default.removeObserver(self)
        
    }
    @objc fileprivate func loginDo(){
        print("登录")
        //发送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }
    @objc fileprivate  func registerDo(){
        print("注册")
    }
    
}




