//
//  EncyclopediaCell.swift
//  DietApp
//
//  Created by user on 03/07/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit
import AlamofireImage


protocol ShareItemDelgate {
    func selectItemShared(img: UIImage, msg: String)
    func selectItemEncycopedia(encycopediaModel: EncyclopediaModel)
}

class EncyclopediaCell: UITableViewCell {

    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblDesc  : UILabel!
    @IBOutlet weak var imgView  : UIImageView!
    @IBOutlet weak var btnReadMore: UIButton!

    @IBOutlet weak var constant_readmore_height: NSLayoutConstraint!

    var delegate: ShareItemDelgate?
    
    var encycopediaModel: EncyclopediaModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.selectionStyle = .none
        imgView.layer.cornerRadius = 3
        imgView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure_cell(tipsModel: EncyclopediaModel) {
        
        self.encycopediaModel = tipsModel
        self.lblTitle.text = tipsModel.title
        self.lblDesc.text = tipsModel.detail
        
        if let imgURL = tipsModel.imgURL {
            self.imgView.af_setImage(withURL: URL(string: imgURL)! ,placeholderImage: #imageLiteral(resourceName: "default_logo_img"),filter: nil,imageTransition: .crossDissolve(0.2))
            self.imgView.contentMode = .scaleAspectFill
        }else{
            self.imgView.contentMode = .center
            self.imgView.image = #imageLiteral(resourceName: "default_logo_img")
        }
        
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
        
        if let containView = self.viewWithTag(11) {containView.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft}
        btnReadMore.contentHorizontalAlignment = isEnglishLang ? .right : .left
        btnReadMore.setTitle(Localization("READ_MORE"), for: .normal)
    }
    
    @IBAction func action_share(){
        let msg = (self.encycopediaModel?.title)! + "\n" + (self.encycopediaModel?.detail)!
        self.delegate?.selectItemShared(img: imgView.image!, msg:msg)
    }
    
    @IBAction func action_read_more(_ sender: Any) {
        self.delegate?.selectItemEncycopedia(encycopediaModel: self.encycopediaModel!)
    }
 
}


