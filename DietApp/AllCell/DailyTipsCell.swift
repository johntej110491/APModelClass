//
//  DailyTipsCell.swift
//  DietApp
//
//  Created by user on 02/07/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

protocol DailyTipsDelgate {
    func selectItemDailyTps(dailyTipsModel: DailyTipsModel)
}

class DailyTipsCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnReadMore: UIButton!

    @IBOutlet weak var constant_readmore_height: NSLayoutConstraint!
    var delegate: DailyTipsDelgate?

    var dailyTipsModel: DailyTipsModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
 
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        // Configure the view for the selected state
    }

    func configure_cell(tipsModel: DailyTipsModel) {
        self.dailyTipsModel = tipsModel
        self.lblTitle.text = tipsModel.title
        self.lblDesc.text = tipsModel.detail
        self.lblTime.text = tipsModel.date
        
        let iHeight = heightForView(text: tipsModel.detail!, font: lblDesc.font, width: lblDesc.frame.size.width)
        if iHeight >= 70 {
            constant_readmore_height.constant =  30
        }else{
            constant_readmore_height.constant = 0
        }
        
        //Language setup
        let CurrentLanguage = UserDefaults_FindData(keyName: APP_LANGUAGE) as! String
        let isEnglishLang: Bool = CurrentLanguage == LanguageSetting.en.rawValue
        self.lblTitle.textAlignment = isEnglishLang ? .left : .right
        self.lblDesc.textAlignment = isEnglishLang ? .left : .right
        self.lblTime.textAlignment = isEnglishLang ? .left : .right
 
        if let containView = self.viewWithTag(11) {containView.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft}
        btnReadMore.contentHorizontalAlignment = isEnglishLang ? .right : .left
        btnReadMore.setTitle(Localization("READ_MORE"), for: .normal)
    }
    
    @IBAction func action_read_more(_ sender: Any) {
        self.delegate?.selectItemDailyTps(dailyTipsModel: self.dailyTipsModel!)
    }
}
