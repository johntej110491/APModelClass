//
//  CaloriesTableVC.swift
//  DietApp
//
//  Created by user on 09/07/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

class CaloriesTableVC: UIViewController {

    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var lblTitleVC: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        connection_calories_list()
    }
    
    private func setting(){
        
        
        //Language setup
        let CurrentLanguage = UserDefaults_FindData(keyName: APP_LANGUAGE) as! String
        let isEnglishLang: Bool = CurrentLanguage == LanguageSetting.en.rawValue
        tblList.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft
        lblTitleVC.text = Localization("FOOD_CALORIES")
        let viewHeader = self.view.viewWithTag(11)
        viewHeader?.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft
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
    //MARK: Calories API
    var caloriesModel = [CaloriesModel]()
    private func connection_calories_list() {
        
        sdLoader.startAnimating(atView: self.view)
        var parameter = [String: String]()
        parameter["request"] = "calories_list"
        
        APIManager.callAPIBYPOST(parameter: parameter, url: BASE_URL) { (response, status) in
            
            if status {
                let isResStatus = response["status"] as? String
                if isResStatus == "true" {
                    if let data = response["data"] as? NSArray {
                        self.caloriesModel = CaloriesModel.modelsFromDictionaryArray(array: data)
                        self.tblList.reloadData()
                    }
                }
            }
            sdLoader.stopAnimation()
        }
    }
}


extension CaloriesTableVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.caloriesModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let CurrentLanguage = UserDefaults_FindData(keyName: APP_LANGUAGE) as! String
        let isEnglishLang: Bool = CurrentLanguage == LanguageSetting.en.rawValue
        let identifier = isEnglishLang ? "Cell" : "CellArebic"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CaloriesCell
        let model = self.caloriesModel[indexPath.row]
        cell.configure_cell(tipsModel: model)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
}
