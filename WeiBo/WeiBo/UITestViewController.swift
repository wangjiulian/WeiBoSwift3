//
//  UITestViewController.swift
//  WeiBo
//
//  Created by wangjl on 2017/6/4.
//  Copyright © 2017年 avery. All rights reserved.
//

import UIKit

class UITestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /// 给指定的图像进行拉伸，并返回 ‘新的’图像
    ///
    /// - Parameters:
    ///   - image: <#image description#>
    ///   - size: <#size description#>
    /// - Returns: <#return value description#>
    func avatarImage(image:UIImage,size:CGSize,backColor:UIColor) -> UIImage? {
        
        let rect = CGRect(origin: CGPoint(), size: size)
        // 1 图像的上下文 - 内存中开辟一个地址，与屏幕无关
        
        /**
         参数:
         1> size 给图的尺寸
         2> 不透明 false/true
         3> sacle 屏幕分辨率，默认生成的图片分辨率默认使用1.0的分辨率。图像质量不好
         可以指定0，会选择当前设备的屏幕分辨率
         */
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        //0背景填充
        backColor.setFill()
        UIRectFill(rect)
        
        
        //1 实例化一个圆形的路径
        let path = UIBezierPath(ovalIn: rect)
        //2 进行路径裁剪 - 后续的绘图，都会出现在圆形路径内部，外部的全部干掉
        path.addClip()
        
        
        //3 绘制内切圆形
        UIColor.darkGray.setStroke()
        path.lineWidth=2
        path.stroke()
        
        // 4 绘图 drawInRect 就是指定区域内拉伸
        image.draw(in:rect)
        
        // 5取得结果
        let result=UIGraphicsGetImageFromCurrentImageContext()
        
        // 6 关闭上下文
        UIGraphicsEndImageContext()
        
        // 7 返回结果
        
        return result
        
        
    }

}
