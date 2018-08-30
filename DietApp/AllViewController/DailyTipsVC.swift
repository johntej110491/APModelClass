//
//  DailyTipsVC.swift
//  DietApp
//
//  Created by user on 02/07/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

class DailyTipsVC: UIViewController {

    var dailyTips = [DailyTipsModel]()
    
    @IBOutlet weak var tblTips: UITableView!
    @IBOutlet weak var lblTitleVC: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        connection_dailyTips()
    }

    private func setting(){
        
        //Language setup
        let CurrentLanguage = UserDefaults_FindData(keyName: APP_LANGUAGE) as! String
        let isEnglishLang: Bool = CurrentLanguage == LanguageSetting.en.rawValue
        tblTips.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft
        let viewHeader = self.view.viewWithTag(11)
        viewHeader?.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft
        lblTitleVC.text = Localization("DAILY_TIPS")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action
    @IBAction func action_back(){
        navigationController?.popViewController(animated: true)
    }

    
    //MARK:-
    //MARK: DailyTips API
    private func connection_dailyTips() {
        
        sdLoader.startAnimating(atView: self.view)
        var parameter = [String: String]()
        parameter["request"] = "DailyTips"
        
        APIManager.callAPIBYPOST(parameter: parameter, url: BASE_URL) { (response, status) in
            
            if status {
                let isResStatus = response["status"] as? String
                if isResStatus == "true" {
                    if let data = response["data"] as? NSArray {
                        self.dailyTips = DailyTipsModel.modelsFromDictionaryArray(array: data)
                        self.tblTips.reloadData()
                        self.tblTips.isHidden = false

                    }
                }
            }
            sdLoader.stopAnimation()
        }
    }
}//End


extension DailyTipsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dailyTips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DailyTipsCell
        let tips = self.dailyTips[indexPath.row]
        cell.configure_cell(tipsModel: tips)
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
}



extension DailyTipsVC: DailyTipsDelgate {
    func selectItemDailyTps(dailyTipsModel: DailyTipsModel) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "TipsDetailVC") as! TipsDetailVC
        vc.getDetail = dailyTipsModel.detail!
        vc.modalPresentationStyle = .overCurrentContext
        navigationController?.present(vc, animated: true, completion: nil)
    }
}
