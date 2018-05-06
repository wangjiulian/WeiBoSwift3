//
//  WBStatusListViewModel.swift
//  WeiBo
//
//  Created by avery on 17/4/22.
//  Copyright © 2017年 avery. All rights reserved.
//

import Foundation
//微博列表视图模型

// 父类的选择

// －如果类需要使用'kvc'或者字典转模型框架设置对象值，类就需要继承NSObject
// -如果类只包装一些代码逻辑（写了一些函数），可以不用任何父类，好处：更加轻盈
// -提示：如果用OC写，一律都继承来自NSObject即可

/*使命
 1.字典转模型
 2.下拉／上拉刷新数据处理
 
 */
class WBStatusListViewModel {
    //微博数据模型懒加载
    lazy var statusList = [WBStatus]()
    /// 加载微博数据
    ///Parameter
    /// -  completion: 返回数据（判是否成功）
    /// - ispullUp：判断是否上啦刷新
    func loadData(ispullUp:Bool,completion:@escaping (_ isSuccess:Bool)->())  {
        //since_id 取出数组中第一天数据id
        // since_id 取出数组的第一条微博的id
        let since_id = ispullUp ? 0 : (statusList.first?.id ?? 0)
        // max_id 取出数组最后一条微博的id
        let max_id = !ispullUp ?  0 : (statusList.last?.id ?? 0)
        print("最后一条数据\(max_id,statusList.last?.text)")
        WBNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (json, isSuccess) in
            if !isSuccess{
                completion(false)
                return
            }
            
            //1 字典转模型
            guard  let array=NSArray.yy_modelArray(with: WBStatus.self, json: json ?? [] ) as? [WBStatus] else{
                completion(false)
                return
            }
            
            print("刷新数据\(array.count)数据")
            //2 拼接数据
            //上拉刷新数据，将数据拼在数组的后面
            if ispullUp{
                self.statusList=self.statusList+array;
            }else{
                //下拉刷新 拼接在数组前面
                self.statusList=array+self.statusList;

            }
            
            
//            print(self.statusList)
            
            //3完成回调
            completion(true)
        }
    }
    
}
