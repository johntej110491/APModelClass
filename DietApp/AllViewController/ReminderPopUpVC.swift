//
//  ReminderPopUpVC.swift
//  DietApp
//
//  Created by user on 29/08/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

protocol ReminderItemDelegate {
    func didSelectIReminderIte(item: String, index: NSInteger)
}

class ReminderPopUpVC: UIViewController {

    var delegate: ReminderItemDelegate?
 
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var lblTitleVC: UILabel!
    @IBOutlet weak var lblMSG: UILabel!
    var isSelecteRemider = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        isSetting()
        
        // Do any additional setup after loading the view.
    }
    
    
    private func isSetting(){
        
        let CurrentLanguage = UserDefaults_FindData(keyName: APP_LANGUAGE) as! String
        let isEnglishLang: Bool = CurrentLanguage == LanguageSetting.en.rawValue
        tblList.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft
        lblTitleVC.text = Localization("REMIND_ME")
        lblMSG.textAlignment = isEnglishLang ? .left : .right
        lblMSG.text = Localization("MSG")
    }
    
    @IBAction func action_back(){
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//MARK;
//MARK: UITableViewDelegate, UITableViewDataSource
extension ReminderPopUpVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ARY_REMINDER.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ReminderPopUpCell
        
        let CurrentLanguage = UserDefaults_FindData(keyName: APP_LANGUAGE) as! String
        let isEnglishLang: Bool = CurrentLanguage == LanguageSetting.en.rawValue
        cell.lblTitle.textAlignment = isEnglishLang ? .left : .right
        
        cell.lblTitle.text = ARY_REMINDER[indexPath.row]
        cell.imgCheck.isHidden = isSelecteRemider == indexPath.row ? false : true
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectIReminderIte(item: ARY_REMINDER[indexPath.row], index: indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
}
