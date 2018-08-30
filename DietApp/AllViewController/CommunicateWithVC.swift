//
//  CommunicateWithVC.swift
//  DietApp
//
//  Created by user on 10/07/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

class CommunicateWithVC: UIViewController {
    
    @IBOutlet weak var lblTitleVC : UILabel!
    @IBOutlet weak var lblMsg : UILabel!
    @IBOutlet weak var btnAskQues : UIButton!
    @IBOutlet weak var btnExpertCall : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
    }
    private func setting(){
        
        btnExpertCall.setImage(userDataModel?.user_gender == "Male" ? #imageLiteral(resourceName: "expert_male") : #imageLiteral(resourceName: "extert_female"), for: UIControlState.normal)
        lblTitleVC.text = Localization("EXPERT_ADVICE")
        lblMsg.text = Localization("EXPERT_MSG")
        btnAskQues.setTitle(Localization("ASK_QUES"), for: .normal)
        btnExpertCall.setTitle(Localization("CALL_TO_EXPERT"), for: .normal)

        //Language setup
        let CurrentLanguage = UserDefaults_FindData(keyName: APP_LANGUAGE) as! String
        let isEnglishLang: Bool = CurrentLanguage == LanguageSetting.en.rawValue
        let viewHeader = self.view.viewWithTag(11)
        viewHeader?.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func action_back(){
        navigationController?.popViewController(animated: true)
    }
    @IBAction func action_expert(){
        phoneCall(num: appDelegate.getExpertNumber! as NSString)
    }
}
