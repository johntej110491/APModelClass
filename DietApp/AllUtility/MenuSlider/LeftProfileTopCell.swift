//
//  LeftProfileTopCell.swift
//  APAuth
//
//  Created by admin on 11/01/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class LeftProfileTopCell: UITableViewCell {
    
    //----------UserProfile-----------
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var viewProfile: UIView!
    @IBOutlet var btnProfile: UIButton!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblEmail: UILabel!

    //----------UserProfile-----------
    @IBOutlet var imgIcon: UIImageView!
    @IBOutlet var lblTitle: UILabel!
     
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func layoutSubviews() {
    super.layoutSubviews()
//        if self.tag == 111 {
//            self.viewProfile.layer.cornerRadius = self.viewProfile.frame.size.width / 2;
//            self.viewProfile.layer.borderColor = UIColor.white.cgColor
//            self.viewProfile.layer.borderWidth = 1;
//            self.viewProfile.layer.masksToBounds = true;
//        }
    }
    
    
}



