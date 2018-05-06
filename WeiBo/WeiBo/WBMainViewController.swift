 //
 //  WBMainViewController.swift
 //  WeiBo
 //
 //  Created by avery on 17/1/5.
 //  Copyright © 2017年 avery. All rights reserved.
 //
 
 // find . -name "*.swift" | xargs wc -l 显示多少行
 
 import UIKit
 import SVProgressHUD
 
 //主控制器 用反射添加主控制器
 class WBMainViewController: UITabBarController {
    
    //定时器
    fileprivate  var timer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildController()
        setComposeBtn()
        setTimenr()
        //设置新特性视图
        setupNewFeature()
        
        //设置代理
        delegate=self
        //发送通知
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
        
    }
    
    
    deinit {
        //销毁时钟
        timer?.invalidate()
        //注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    lazy var composeBtn=UIButton()
    
    
    /*
     
     /// portrait  :横屏，肖像
     /// landscape :横屏，风景相
     -使用代码控制设备方向，好处，可以在在需要的时候，单独处理！
     －设置支持的方向之后，当前的控制器及子控制器都会遵守这个方向！
     － 如果视频播放，通常通过 modal展现的
     
     */
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        
        return .portrait
    }
    
    
    //    //MARK:监听方法
    //    func composeStatus(){
    //        print("点击")
    //    }
    //MARK:监听方法
    
    //MARK:监听方法
    @objc fileprivate  func userLogin(n:Notification){
        print("收到通知\(n)")
        
        var when = DispatchTime.now()
        
        //判断n.object 是否有值，token过期-提示用户重新登录
        if n.object != nil {
            //设置指示器渐变样式
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.showInfo(withStatus: "用户登录已经超时，需重新连接")
            // 修改延迟时间
            when = DispatchTime.now() + 2
        }
        DispatchQueue.main.asyncAfter(deadline: when) {
            SVProgressHUD.setDefaultMaskType(.clear)//默认
            let nv=UINavigationController(rootViewController: WBOAuthViewController())
            //        let vc=WBOAuthViewController()
            //跳转
            self.present(nv, animated: true, completion: nil)
            
        }
    }
 }
 
 
 // MARK - 新特性视图处理
 extension WBMainViewController{
    
    // 设置新特性视图
    fileprivate func setupNewFeature(){
        
        // 0 判断是否登录
        if !WBNetworkManager.shared.userLogon{
            return
        }
        
        //1 检查版本是否更新
        
        //2 如果更新，显示新特性,否则显示欢迎
        let v = isNewVersion ? WBNewFeatureView.NewFeatureView() : WBWelcomeView.welcomeVIew()
        
        //3 添加视图
//        v.frame=view.bounds
        view.addSubview(v)
        
    }
    
    //计算型属性
    // extension中可以有计算型属性，不会占用存储空间
    // 构造函数给属性分配空间
    /*
     版本号
     -在APpStore 每次升级应用程序，版本号都要增加
     - 组成 主版本号，次版本号，修订版本号
     - 主版本号：意味着大的修改，使用者也需要做大的适应
     - 次版本号：意味着小的修改，某些函数和方法的使用或者参数有变化
     - 修订版本号：框架、程序内部bug的修订，不会对使用者造成任何的影响
     
     */
    private var isNewVersion : Bool{
        
        // 1.取当前版本号
        print(Bundle.main.infoDictionary)
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        // 2.去保存在 Docuemnt[iTunes备份][理想保存在偏好] 目录中的之前版本号
        let path : String = ("version" as NSString).cz_appendDocumentDir() ?? ""
        let sandBoxVersion = try? String(contentsOfFile: path)
        // 3 将当期版本号保存在沙盒
        _ = try? currentVersion.write(toFile: path, atomically: true, encoding: .utf8)
        
        // 4 返回两个版本号是否一致
        
        return currentVersion != sandBoxVersion
//        return currentVersion == sandBoxVersion

    }
 }
 
 
 extension WBMainViewController:UITabBarControllerDelegate{
    
    /// 将要选择TabBarItem
    ///
    /// - Parameters:
    ///   - tabBarController: tabBarController
    ///   - viewController: 目标控制器
    /// - Returns: 是否切换到目标控制器
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("将要切换到\(viewController)")
        
        // 1获取控制器数组中的索引
        let idx = childViewControllers.index(of: viewController)
        
        // 2 判断当前索引是首页，，同时idx也是首页重复点击
        
        if selectedIndex==0 && idx==selectedIndex {
            //3 滚动到首页
            // 4获取控制器
            let nav=childViewControllers[0] as! UINavigationController
            
            let vc=nav.childViewControllers[0] as! WBHomeViewController
            
            // 滚动到顶部
            vc.tableView?.setContentOffset(CGPoint(x:0,y:-64), animated: true)
            
            // 刷新不急--增加延迟，保证表格先滚动到顶部在刷新
            //数据刷新
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                vc.loadData()
            })
            //            vc.loadData()
            
            //5 清除tabbarItem的badgeNumber

            vc.tabBarItem.badgeValue=nil
            UIApplication.shared.applicationIconBadgeNumber=0
            
        }
        //判断目标控制器是否是UIVIewControl
        return  !viewController.isMember(of: UIViewController.self)
        
        
    }
 }
 
 
 // MARK: - 时钟相关方法
 extension WBMainViewController{
    //定义时钟
    fileprivate  func setTimenr(){
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector:#selector(updateTime), userInfo: nil, repeats: true)
        
    }
    
    //时钟方法
    @objc private  func updateTime() {
        if !WBNetworkManager.shared.userLogon {
            return        }
        
        WBNetworkManager.shared.unreadCount { (count) in
            //            print("监测到\(count)条刷新微博")
            //设置首页tabBaritem的badgeNumber
            self.tabBar.items?[0].badgeValue=count > 0 ? "\(count)" : nil
            
            //设置App 的badgeNumber 从IOS8.0 要用户授权才能显示
            UIApplication.shared.applicationIconBadgeNumber = count
        }
        
    }
    
 }
 
 
 //extension 类似于OC中的分类，在swift还可以用来切分代码块，可以相同想近功能的函数。放在一个extension中
 //便于维护
 //注意:和OC一样，不能定义属性
 //MARK:-设置界面
 extension WBMainViewController{
    //设置纂写按钮
    func setComposeBtn()  {
        composeBtn.setImage(UIImage(named: "tabbar_compose_icon_add"), for:.normal)
        composeBtn.setImage(UIImage(named:"tabbar_compose_icon_add_highlighted"), for: .highlighted)
        composeBtn.backgroundColor=UIColor.orange
        //        composeBtn.setTitle("普通状态", for:.normal) //普通状态下的文字
        //        composeBtn.setTitle("触摸状态", for:.highlighted) //触摸状态下的文字
        //        composeBtn.setTitle("禁用状态", for:.disabled) //禁用状态下的文字
        tabBar.addSubview(composeBtn)
        //计算宽度
        let count=CGFloat(childViewControllers.count)
        //将向内的缩进宽度减少
        let w=view.bounds.width/count
        //insetBy往里缩进  CGRectInset     整数向内缩进，负数向外扩展
        composeBtn.frame=tabBar.bounds.insetBy(dx: 2*w, dy: 0)
        print("宽度\(composeBtn.bounds.width)")
        
        //按钮监听方法
        composeBtn.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
        
    }
    
    
    //设置所有子控制器
    func setupChildController(){
        
        // 0 从沙盒中获取json路径
        let docDir=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath=(docDir as NSString).appendingPathComponent("main.json")
        var data=NSData(contentsOfFile: jsonPath)
        
        
        if data==nil {
            //判断data是否有内容，如果没有，说明沙盒没有文件
            //从Bundle加载data
            let path=Bundle.main.path(forResource: "main.json", ofType: nil);
            data=NSData(contentsOfFile: path!)
            
        }
        
        //        //从Bundle加载json
        //        //1.路径/2.NSData/3.反序列和转换成数组
        //        guard let path=Bundle.main.path(forResource: "main.json", ofType: nil),
        //            let data=NSData(contentsOfFile: path),
        //            let array=try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [[String:AnyObject]]else {
        //
        //            return
        //        }
        //
        //data反序列化转换成数组
        guard let array=try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String:AnyObject]]  else {
            return
        }
        
        /// <#Description#>
        //                let array:[[String:AnyObject]]=[
        //                    ["className":"WBHomeViewController" as AnyObject,"title":"首页" as AnyObject,"imageName":"home" as AnyObject
        //                        ,"visitorInfo":["imageName":"","message":"关注一些人，回这块看看有什么惊喜"] as AnyObject],
        //
        //                    ["className":"WBMessageViewController" as AnyObject,"title":"消息" as AnyObject,"imageName":"message_center" as AnyObject ,"visitorInfo":["imageName":"visitordiscover_image_message","message":"登录后，别人评论你的微薄，发给你信息，都在这里收到通知"] as AnyObject],
        //
        //                    ["className":"" as AnyObject],
        //
        //                    ["className":"WBDiscoverViewController" as AnyObject ,"title":"发现"as AnyObject ,"imageName":"discover" as AnyObject ,"visitorInfo":["imageName":"visitordiscover_image_message","message":"登录后，最新组、最热微薄尽在掌握，不会再与实事潮流擦肩而过"] as AnyObject],
        //
        //                    ["className":"WBProfileViewController" as AnyObject,"title":"我的" as AnyObject,"imageName":"profile" as AnyObject ,"visitorInfo":["imageName":"visitordiscover_image_profile","message":"登录后，你的微薄、相册、个人资料都会显示在这里，展示给别人"] as AnyObject]
        //                ]
        //                //测试数据格式是否正确，-转换成plist更直观
        //                //(array as NSArray).write(toFile: "Users/wangjiulian/Desktop/demo.plist", atomically: true)
        //                //数组-> json序列化
        //                let data = try? JSONSerialization.data(withJSONObject: array, options: [.prettyPrinted])
        //
        //                (data as! NSData).write(toFile: "Users/wangjiulian/Desktop/demo.json", atomically: true)
        //
        
        var arryM=[UIViewController]()
        for dict in array!{
            
            arryM.append(contorller(dic: dict))        }
        //
        //设置tarBar的子控制器
        viewControllers=arryM
        
    }
    //使用字典创建一个字控制器
    // 字典信息：［className,title,imageName］
    private func contorller(dic:[String:AnyObject])->UIViewController{
        //1 获取字典
        guard   let clsName=dic["className"] as? String,
            let title=dic["title"] as? String,
            let  imageName=dic["imageName"] as? String,
            let cls=NSClassFromString(Bundle.main.nameSpace()+"."+clsName) as? WBBaseViewController.Type,
            let  visitorDic=dic["visitorInfo"] as? [String:String]
            else {
                return UIViewController()
        }
        //2创建视图
        //将className转cls
        //UIViewController
        let vc=cls.init()
        //设置数据
        vc.visitorInfoDic=visitorDic;
        vc.title=title
        //设置图片
        vc.tabBarItem.image=UIImage(named: "tabbar_"+imageName)
        vc.tabBarItem.selectedImage=UIImage(named: "tabbar_"+imageName+"_selected")?.withRenderingMode(.alwaysOriginal)
        //设置tabBar字体选中颜色（大小）
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.orange], for:.highlighted)
        //默认12号 设置normal状态才有效
        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 16)], for: UIControlState(rawValue: 0))
        //加到nav中，并返回
        //WBNavigationController
        //会掉用pushViewController方法
        //实力化导航控制器时候，会调用push方法压入帐
        let nav=WBNavigationController(rootViewController: vc)
        return nav
        
        
    }
    @objc private func composeStatus(){
        print("点击")
        
        let vc=UIViewController()
        vc.view.backgroundColor=UIColor.cz_random()
        let nav=UINavigationController(rootViewController:vc)
        present(nav, animated: true, completion: nil)
        
        
    }
 }
 
