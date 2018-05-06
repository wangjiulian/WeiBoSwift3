//
//  WBOAuthViewController.swift
//  WeiBo
//
//  Created by wangjl on 2017/4/29.
//  Copyright © 2017年 avery. All rights reserved.
//

import UIKit
import SVProgressHUD
//通过webview加载新浪微博授权页面控制器
class WBOAuthViewController: UIViewController {
    
    
    private lazy var webview = UIWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //加载授权页面
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppkey)&&redirect_uri=\(WBRedirectURI)"
        // 1 URL确定访问资源
        guard  let url=URL(string: urlString) else{
            
            return
        }
        
        //建立请求
        let request = URLRequest(url: url)
        
        //加载请求
        webview.loadRequest(request)
        
        
    }
    
    override func loadView() {
        webview.delegate=self
        view = webview
        view.backgroundColor=UIColor.white
        //取消滑动视图 - 新浪微博的服务器，返回的授权页面默认是手机全屏
        webview.scrollView.isScrollEnabled=false
        //设置
        title="登录新浪微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", fontSize: 16, target: self, action: #selector(close), isBack: true)
        navigationItem.rightBarButtonItem=UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFill))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //监听方法
    @objc fileprivate func close(){
        dismiss(animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
    
    //自动填充 - webview的注入，直接通过js修改‘本地浏览器中缓存的页面’
    @objc private func autoFill() {
        
        //准备js
        let js = "document.getElementById('userId').value = '15985866257';" +
        "document.getElementById('passwd').value = 'Just333999';"
        //执行js
        webview.stringByEvaluatingJavaScript(from: js)
        
    }
    
    
}
extension WBOAuthViewController:UIWebViewDelegate{
    
    /// webview 将要请求
    ///
    /// - Parameters:
    ///   - webView: webview
    ///   - request: 要加载的请求
    ///   - navigationType: 导航类型
    /// - Returns: 是否加载 request
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 确认思路
        // 1 如果请求地址当中包括http://baidu.com不加载页面 否则加载页面
        //    if request.url?.absoluteString.hasPrefix(WBRedirectURI） 返回可选项true/false/nil
        if request.url?.absoluteString.hasPrefix(WBRedirectURI) == false {

            return true
        }
//        print("加载请求---\(request.url?.absoluteString)")
//        //query 就是URL 中 ‘？’后面的所有部分
//        print("加载请求---\(request.url?.query)")
        // 2 从http://baidu.com 回调地址的查询字母串中查找 'code='
        // 如果有，授权成功。否则，授权失败
        if request.url?.query?.hasPrefix("code=") == false {
            
            print("取消授权")
            self.close()
           return false
        }
        
        // 3 从query字符串中取出授权码
        // 肯定有查询字符串，一定有code
    let code =  request.url?.query?.substring(from: "code=".endIndex) ?? ""
        
        print("code=\(code)")
        //使用授权码（换取accessToken
        WBNetworkManager.shared.loadAccessToken(code: code) { (isSuccess) in
            if !isSuccess{
             SVProgressHUD.showInfo(withStatus: "网络请求失败")
            }else{
                SVProgressHUD.showInfo(withStatus: "登录成功")
            }
      
            // 下一步做什么?跳转界面? 如何跳转
            
            //1 发送通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserLoginSuccessNotification), object: nil)
            
            //2 关闭窗口
            self.close()
        }

        SVProgressHUD.dismiss()
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}
