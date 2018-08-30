//
//  AskQuestionVC.swift
//  DietApp
//
//  Created by user on 10/07/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

class AskQuestionVC: UIViewController {

    @IBOutlet weak var scrollMain  : UIScrollView!
    @IBOutlet weak var tblList  : UITableView!
    @IBOutlet var lblTopCounter : UILabel!
    @IBOutlet weak var txtMsg : UITextField!
    @IBOutlet weak var btnSend : UIButton!

    @IBOutlet weak var lblPopupCounter: UILabel!
    @IBOutlet weak var lblPopupMsg: UILabel!
    
    @IBOutlet weak var lblTitleVC: UILabel!

    @IBOutlet weak var lblQuestionTitle: UILabel!

    
    
    
    var askQuestionModel = [AskQuestionModel]()
    
    @IBOutlet weak var viewRemainPopup : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        connection_askQuestionList()

    }
    private func setting(){
        
        lblTitleVC.text = Localization("EXPERT_ADVICE")
        lblPopupMsg.text = Localization("EXPERT_MSG")
        lblQuestionTitle.text = Localization("QUESTIONS")
        txtMsg.placeholder = Localization("ASK_SOMETHING")
        
        //Language setup
        let CurrentLanguage = UserDefaults_FindData(keyName: APP_LANGUAGE) as! String
        let isEnglishLang: Bool = CurrentLanguage == LanguageSetting.en.rawValue
        if let viewMain = self.view.viewWithTag(55555) {
            viewMain.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft
        }
        if let viewTextTool = self.scrollMain.viewWithTag(11) {
            viewTextTool.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft
        }
        
        txtMsg.textAlignment = isEnglishLang ? .left : .right
        
        lblQuestionTitle.textAlignment = isEnglishLang ? .left : .right
        lblTopCounter.textAlignment = isEnglishLang ? .right : .left
        self.tblList.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft
        
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

    @IBAction func action_dissmissPopup(){
        self.viewRemainPopup.removeFromSuperview()
    }
    
    
    @IBAction func action_send(){
        if trim(str: txtMsg.text!).count != 0 {
            connection_send_question()
        }
    }
    
  
    
    private func connection_send_question() {
        
        sdLoader.startAnimating(atView: self.view)
        var parameter = [String: String]()
        parameter["request"] = "insert_query"
        parameter["user_id"] = userDataModel?.user_id
        parameter["queries"] = self.txtMsg.text!

        APIManager.callAPIBYPOST(parameter: parameter, url: BASE_URL) { (response, status) in
            
            print(response)
            if status {
                let isResStatus = response["status"] as? String
                if isResStatus == "true" {
                    self.txtMsg.text = ""

                    if let data = response["data"] as? NSArray {
                        self.askQuestionModel = [AskQuestionModel]()
                        self.askQuestionModel = AskQuestionModel.modelsFromDictionaryArray(array: data)
                        self.tblList.reloadData()
                        
                        self.lblTopCounter.text = self.questionCounter()
                        self.lblPopupCounter.text = self.lblTopCounter.text
                        self.viewRemainPopup.frame = self.view.bounds
                        self.view.addSubview(self.viewRemainPopup)

                    }
                }else{
                    if let msg = response["msg"] {
                        iSSnackbarShow(message: msg as! String)
                    }
                }
            }
            sdLoader.stopAnimation()
        }
    }
    
    private func connection_askQuestionList() {
        
        sdLoader.startAnimating(atView: self.view)
        var parameter = [String: String]()
        parameter["request"] = "query_list"
        parameter["user_id"] = userDataModel?.user_id
        
        APIManager.callAPIBYPOST(parameter: parameter, url: BASE_URL) { (response, status) in
            
            print(response)
            if status {
                let isResStatus = response["status"] as? String
                if isResStatus == "true" {
                    if let data = response["data"] as? NSArray {
                        self.askQuestionModel = AskQuestionModel.modelsFromDictionaryArray(array: data)
                        self.tblList.reloadData()
                        self.lblTopCounter.text = self.questionCounter()
                        self.lblPopupCounter.text = self.lblTopCounter.text
                    }
                    
                }
                
//                if let iCount = response["count"] as? String {
//                    self.lblTopCounter.text = iCount
//                    self.lblPopupCounter.text = self.lblTopCounter.text
//                }
                self.viewRemainPopup.frame = self.view.bounds
                self.view.addSubview(self.viewRemainPopup)
            }
            sdLoader.stopAnimation()
        }
    }
    private func questionCounter() -> String {
        let ask = self.askQuestionModel.filter { (b1) -> Bool in
            return b1.user_id == userDataModel?.user_id
        }
        return "\(ask.count)/3"
    }
}


extension AskQuestionVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return askQuestionModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.askQuestionModel[indexPath.row]

        if model.user_id == "Admin" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnsCell", for: indexPath) as! AnswerCell
            cell.lblTitle.text = "Admin"
            cell.lblDetail.text = model.msg
            cell.lblDate.text = model.date
            
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AskQuestionsCell
            cell.lblTitle.text = userDataModel?.user_name
            cell.lblDetail.text = model.msg
            cell.lblDate.text = model.date
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
}

extension AskQuestionVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
