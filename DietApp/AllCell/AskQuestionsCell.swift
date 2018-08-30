//
//  AskQuestionsCell.swift
//  DietApp
//
//  Created by user on 10/07/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

class AskQuestionsCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle      : UILabel!
    @IBOutlet weak var lblDetail     : UILabel!
    @IBOutlet weak var lblDate       : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        //Language setup
        let CurrentLanguage = UserDefaults_FindData(keyName: APP_LANGUAGE) as! String
        let isEnglishLang: Bool = CurrentLanguage == LanguageSetting.en.rawValue
        self.lblTitle.textAlignment = isEnglishLang ? .left : .right
        self.lblDetail.textAlignment = isEnglishLang ? .left : .right
        self.lblDate.textAlignment = isEnglishLang ? .right : .left
        
        //self.contentView.semanticContentAttribute = isTrue ? .forceLeftToRight : .forceRightToLeft
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}





class AnswerCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle      : UILabel!
    @IBOutlet weak var lblDetail     : UILabel!
    @IBOutlet weak var lblDate       : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        //Language setup
        let CurrentLanguage = UserDefaults_FindData(keyName: APP_LANGUAGE) as! String
        let isEnglishLang: Bool = CurrentLanguage == LanguageSetting.en.rawValue
        self.lblTitle.textAlignment = isEnglishLang ? .left : .right
        self.lblDetail.textAlignment = isEnglishLang ? .left : .right
        self.lblDate.textAlignment = isEnglishLang ? .right : .left
        
        //self.contentView.semanticContentAttribute = isTrue ? .forceLeftToRight : .forceRightToLeft
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
