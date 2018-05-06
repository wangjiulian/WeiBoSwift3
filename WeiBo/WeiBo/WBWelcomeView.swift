//
//  WBWelcomeView.swift
//  WeiBo
//
//  Created by wangjl on 2017/5/2.
//  Copyright © 2017年 avery. All rights reserved.
//

import UIKit
import SDWebImage
class WBWelcomeView: UIView {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    @IBOutlet weak var tipLabel: UILabel!
    class func welcomeVIew()-> WBWelcomeView{
        
        let nib = UINib(nibName: "WBWelcomeView", bundle: nil)
        
        let v=nib.instantiate(withOwner: nib, options: nil)[0] as! WBWelcomeView
        
        //从xib加载的视图 默认是600*600
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //提示：initWithCode 只是刚从XIB的二进制文件将视图数据加载完成
        //还没有和代码连线建立关系，所以开发时，千万不能在这个方法中处理UI
    }
    
    override func awakeFromNib() {
        
//         1. url
        
        guard let urlString = WBNetworkManager.shared.userAccount.avatar_large,
            let url = URL(string: urlString)
            else {
                return
        }
//        2. 设置头像-如果网络图像没有下载完成，先显示占位图
        // 如果不指定占位图，之前设置的图像会被清空!
        iconImageView.sd_setImage(with: url)
        //设置圆角的iconImageView bounds还没有设置
        iconImageView.layer.cornerRadius = 42.5
        iconImageView.layer.masksToBounds = true
             
    }
    
    /// 自动布局系统更新完成约束后，会自动调用此方法
    
    /// 通常是对子视图布局进行修改
    override func layoutSubviews() {
        
        
    }
    
    /// 视图被添加到window上，表示视图已经显示
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        
        //  视图是使用自动布局来设置的，只是设置了约束
        //  -当视图被添加到窗口上时，根据父视图的大小，计算约束值，更新控件位置
        //  -layoutIfNeeded 会直接按照当前的约束条件直接更新控件位置
        //  -执行之后，控件所在位置，就是XIB中布局的位置
        
        self.layoutIfNeeded()
        bottomCons.constant = bounds.height-200;
        //如果控件们frame还没有计算好，所有的约束会一起动画！
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            //更新约束条件
            self.layoutIfNeeded()
        }) { (_) in
            
           UIView.animate(withDuration: 1.0, animations: { 
            self.tipLabel.alpha=1
           }, completion: { (_) in
            self.removeFromSuperview()
           })
        }
        
}
}
