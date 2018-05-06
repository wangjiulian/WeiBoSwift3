//
//  WBTitleButton.swift
//  WeiBo
//
//  Created by wangjl on 2017/5/1.
//  Copyright © 2017年 avery. All rights reserved.
//

import UIKit

class WBTitleButton: UIButton {
    
    
    /// 重载构造函数
    ///
    /// - Parameter title: 如果是nil 就显示首页
    /// 如果不为nil，显示title和图像
    init(title: String) {
        super.init(frame:CGRect())
        
        // 判断title 是否为nil
        if title==nil {
            setTitle("首页", for: [])
        }else{
            setTitle(title+" ", for: [])
            setImage(UIImage(named:"navigationbar_arrow_down"), for: [])
            setImage(UIImage(named:"navigationbar_arrow_up"), for: .selected)
        }
        
        // 2 设置字体颜色
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: [])
        
        // 3 设置大小
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 重新布局子视图
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let titleLabel = titleLabel,
            let imageView = imageView else {
            return
        }
//
//        // 将label的x向左移动imageview宽度
//        titleLabel.frame=titleLabel.frame.offsetBy(dx: -imageView.bounds.width, dy: 0)
//        
        //将imageview的x向右移动label的宽度
       imageView.frame=imageView.frame.offsetBy(dx: titleLabel.bounds.width+5, dy: 0)
    }
}
