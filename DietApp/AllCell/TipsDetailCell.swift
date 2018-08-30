//
//  TipsDetailCell.swift
//  DietApp
//
//  Created by user on 20/07/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

class TipsDetailCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    var dailyTipsModel: DailyTipsModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure_cell(tipsModel: DailyTipsModel) {
        self.dailyTipsModel = tipsModel
        self.lblTitle.text = tipsModel.title
        
  

        
        
        
    }
}
