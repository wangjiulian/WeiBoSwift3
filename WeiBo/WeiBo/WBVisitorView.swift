//
//  WBVisitorView.swift
//  WeiBo
//
//  Created by wangjl on 2017/4/14.
//  Copyright © 2017年 avery. All rights reserved.
//

import UIKit

/// 访客视图
class WBVisitorView: UIView {
    // 注册按钮
     var registerButton:UIButton=UIButton.cz_textButton("注册", fontSize: 16, normalColor: UIColor.orange, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")
    //登录按钮
     var loginButton:UIButton=UIButton.cz_textButton("登录", fontSize: 16, normalColor: UIColor.orange, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")
    

    
    //访客视图字典
    var visitorInfo:[String:String]?{
        didSet{
            //1 获取字典信息
            guard  let imageName=visitorInfo?["imageName"]
                ,let message=visitorInfo?["message"]
                else{
                    return
            }
            //2 设置消息
            tipLabel.text=message
            
            //3 设置图像
            if imageName==""{
                setAninotion()
                return
            }
            
            //其他视图 不用显示小房子
            
            iconView.image=UIImage(named: imageName)
            iconView.layer.removeAllAnimations()
            houseIconView.isHidden=true
            maskIconView.isHidden=true
            
        }
    }
    // MARK:构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
      setUpUi()
    }

    
    
    /// 旋转图标动画
    private  func setAninotion(){

        let anim=CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue=2*Double.pi//旋转角度
        anim.repeatCount=MAXFLOAT//不停旋转
        anim.duration=15;//一圈旋转时间
        //在设置连续播放很有作用
        //动画完成不删除  如果iconView被释放，动画会一起销毁
        anim.isRemovedOnCompletion=false
        //将动画添加到图层
      iconView.layer.add(anim, forKey: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -设置访客视图
    
    ///
    ///
    /// - Parameter dict:[imageName/message]
    // 提示：如果是首页
    func setupInfo(dict:[String:String])  {
        
    }
}
//MARK:-私有控件
//懒加载属性只有调用UIKit控件的指定构造函数，其他都需要使用类型
//图像视图
//转轮
private var iconView:UIImageView=UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
//遮罩
private var maskIconView:UIImageView=UIImageView(
    image: UIImage(named:"visitordiscover_feed_mask_smallicon"))
//小房子
private var houseIconView=UIImageView(image: UIImage(named:"visitordiscover_feed_image_house"))

//提示标签
private var tipLabel:UILabel=UILabel.cz_label(
    withText: "关注一些人，会这里看看有什么惊喜",
    fontSize: 16, color: UIColor.darkGray)
extension WBVisitorView{
    
    func setUpUi(){
        //0 在开发的时候，如果能够使用颜色，就不用使用图像，效率会更高
        
        backgroundColor=UIColor.cz_color(withHex: 0xEdEdEd)
        
        //1 添加控件
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseIconView)
        addSubview(tipLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        //文本居中
        tipLabel.textAlignment = .center
        //2 取消autoresizing  使用auntolayout xib 默认是autolayout
        for v  in subviews{
            v.translatesAutoresizingMaskIntoConstraints=false
        }
        
        //3 自动布局
        // 1.图像视图
        //
        addConstraint(NSLayoutConstraint(
            item: iconView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0))
        //设置y
        addConstraint(NSLayoutConstraint(
            item: iconView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1.0,
            constant: -60))
        
        // 2.小房子
        addConstraint(NSLayoutConstraint(
            item: houseIconView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: iconView,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0))
        //设置y
        addConstraint(NSLayoutConstraint(
            item: houseIconView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: iconView,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0
        ))
        
        // 3.标签
        addConstraint(NSLayoutConstraint(
            item: tipLabel,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: iconView,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0))
        //tipLabel top 与 iconView bottom对齐
        addConstraint(NSLayoutConstraint(
            item: tipLabel,
            attribute: .top,
            relatedBy: .equal,
            toItem: iconView,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0))
        //设置宽度
        addConstraint(NSLayoutConstraint(
            item: tipLabel,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 236))
        
        // 4. 注册按钮
        addConstraint(NSLayoutConstraint(
            item: registerButton,
            attribute: .left,
            relatedBy: .equal,
            toItem: tipLabel,
            attribute: .left,
            multiplier: 1.0,
            constant: 0))
        addConstraint(NSLayoutConstraint(
            item: registerButton,
            attribute: .top,
            relatedBy: .equal,
            toItem: tipLabel,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0))
        //设置宽度
        addConstraint(NSLayoutConstraint(
            item: registerButton,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 100))
        // 5. 登录按钮
        addConstraint(NSLayoutConstraint(
            item: loginButton,
            attribute: .right,
            relatedBy: .equal,
            toItem: tipLabel,
            attribute: .right,
            multiplier: 1.0,
            constant: 0))
        addConstraint(NSLayoutConstraint(
            item: loginButton,
            attribute: .top,
            relatedBy: .equal,
            toItem: tipLabel,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0))
        //设置宽度
        addConstraint(NSLayoutConstraint(
            item: loginButton,
            attribute: .width,
            relatedBy: .equal,
            toItem: registerButton,
            attribute: .width,
            multiplier: 1.0,
            constant: 0))
        
        
        
        //6 遮罩图像
        // views:定义VFL 中的控件名称和实际名称映射关系
        // metrics:定义VFL中（）指定常数映射关系
        let metrics=["spacing":-20]
        let viewDic=["maskIconView":maskIconView,"registerButton":registerButton] as [String : Any]
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[maskIconView]-0-|",
            options: [],
            metrics: nil,
            views: viewDic))
        
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[maskIconView]-(spacing)-[registerButton]",
            options: [],
            metrics: metrics,
            views: viewDic))
    
    }
}
