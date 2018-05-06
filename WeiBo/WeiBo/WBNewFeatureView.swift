//
//  WBNewFeatureView.swift
//  WeiBo
//
//  Created by wangjl on 2017/5/2.
//  Copyright © 2017年 avery. All rights reserved.
//

import UIKit

class WBNewFeatureView: UIView {
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBAction func enterStatus() {
        removeFromSuperview()
    }
    class func NewFeatureView()-> WBNewFeatureView{
        
        let nib = UINib(nibName: "WBNewFeatureView", bundle: nil)
        
        let v=nib.instantiate(withOwner: nib, options: nil)[0] as! WBNewFeatureView
        
        //从xib加载的视图 默认是600*600
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    override func awakeFromNib() {
        
        //如果使用自动布局,从xib加载默认是600*600 大小
        //添加4个图像视图
        
        let count = 4;
        let rect=UIScreen.main.bounds
        
        for i in 0..<count{
            
            let imageName="new_feature_\(i+1)"
            let iv=UIImageView(image: UIImage(named: imageName))
            
            //设置大小 比如第一个  index=0 从0到一个屏幕往内缩进, index=1  从一个屏幕宽度位置往两个屏幕位置往内缩进
            
            iv.frame = rect.offsetBy(dx: CGFloat(i)*rect.width, dy: 0)
    
            scrollview.addSubview(iv)
            
        }
        
        
        //指定scroolview属性 
        //设置scrollView的内容区域大小
        scrollview.contentSize=CGSize(width: CGFloat(count+1)*rect.width, height: rect.height)

        
        scrollview.delegate=self
        scrollview.bounces=false//取消回弹 true滑动到边界时会直接定在边界就不会有弹动的效果。
        scrollview.isPagingEnabled=true//设置是否支持整页滚动
        scrollview.showsVerticalScrollIndicator=false//不显示垂直滑动条
        scrollview.showsHorizontalScrollIndicator=false//不显示水平滑动条
        
        //隐藏按钮
        endButton.isHidden=true
    }
}

extension WBNewFeatureView:UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //1 滚动到最后一屏，让视图删除
        let page = Int(scrollview.contentOffset.x/scrollview.bounds.width)
        
        print(page)
        //2 判断是否最后一页
        if page==scrollview.subviews.count{
         print("欢迎欢迎，热烈欢迎")
           removeFromSuperview()
        }
        
        //3 如果是倒数第二页，显示加载
        endButton.isHidden = (page != scrollview.subviews.count-1)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    //0  一旦滚动隐藏按钮
        endButton.isHidden=true
    
    //1 计算当前偏移量
        let page=Int(scrollview.contentOffset.x/scrollview.bounds.width+0.5)
        
    //2 设置分页控件
    pageControl.currentPage = page
        
        
     
     
    }
}
