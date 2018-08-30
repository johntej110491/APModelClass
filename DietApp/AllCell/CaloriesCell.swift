//
//  CaloriesCell.swift
//  DietApp
//
//  Created by user on 09/07/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

class CaloriesCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle : UILabel!
    
    @IBOutlet weak var lblProtein  : UILabel!
    @IBOutlet weak var lblCarbohy  : UILabel!
    @IBOutlet weak var lblQuantity  : UILabel!
    @IBOutlet weak var lblFats  : UILabel!
    @IBOutlet weak var lblFiber  : UILabel!
    
    @IBOutlet weak var lblProteinMsg  : UILabel!
    @IBOutlet weak var lblCarbohyMsg  : UILabel!
    @IBOutlet weak var lblQuantityMsg  : UILabel!
    @IBOutlet weak var lblFatsMsg  : UILabel!
    @IBOutlet weak var lblFiberMsg  : UILabel!
    //Language setup
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    func configure_cell(tipsModel: CaloriesModel) {
        self.lblTitle.text = tipsModel.title
        self.lblProtein.text = tipsModel.protein
        self.lblCarbohy.text = tipsModel.carbohydrates
        self.lblQuantity.text = tipsModel.quantity
        self.lblFats.text = tipsModel.fats
        self.lblFiber.text = tipsModel.fiber

        lblProteinMsg.text = Localization("PROTEIN")
        lblCarbohyMsg.text = Localization("CARBOHY")
        lblQuantityMsg.text = Localization("QUANTITY")
        lblFatsMsg.text = Localization("FATS")
        lblFiberMsg.text = Localization("FIBER")
    }
}
