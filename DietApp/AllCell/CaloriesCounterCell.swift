//
//  CaloriesCounterCell.swift
//  DietApp
//
//  Created by user on 19/07/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

class CaloriesCounterCell: UITableViewCell {
  
    @IBOutlet weak var lblQuan: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
