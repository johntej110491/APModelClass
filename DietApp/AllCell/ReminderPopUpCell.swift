//
//  ReminderPopUpCell.swift
//  DietApp
//
//  Created by user on 29/08/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

class ReminderPopUpCell: UITableViewCell {
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
