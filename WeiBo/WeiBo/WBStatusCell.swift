//
//  WBStatusCell.swift
//  WeiBo
//
//  Created by wangjl on 2017/7/24.
//  Copyright © 2017年 avery. All rights reserved.
//

import UIKit

class WBStatusCell: UITableViewCell {

    /// 正文
    @IBOutlet weak var statusLabel: UILabel!
    /// vip图像
    @IBOutlet weak var vipIconView: UIImageView!
    ///来源
    @IBOutlet weak var sourceLabel: UILabel!
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 会员类型图片
    @IBOutlet weak var memberIconView: UIImageView!
    /// 姓名
    @IBOutlet weak var nameLabel: UILabel!
    /// 头像

    @IBOutlet weak var iconView: UIImageView!
      
    override func awakeFromNib() {
               super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
