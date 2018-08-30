//
//  EncyclopediaListVC.swift
//  DietApp
//
//  Created by user on 03/07/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

class EncyclopediaListVC: UIViewController {

    @IBOutlet weak var tblEncyclopedia: UITableView!
    @IBOutlet weak var lblTitleVC: UILabel!
    
    var encyclopediaModel = [EncyclopediaModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        connection_encyclopedia_list()
        //tblEncyclopedia.semanticContentAttribute = .forceRightToLeft
        // Do any additional setup after loading the view.
    }
    private func setting(){
        
        //Language setup
     
        let CurrentLanguage = UserDefaults_FindData(keyName: APP_LANGUAGE) as! String
        let isEnglishLang: Bool = CurrentLanguage == LanguageSetting.en.rawValue
        tblEncyclopedia.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft
        let viewHeader = self.view.viewWithTag(11)
        viewHeader?.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft
        lblTitleVC.text = Localization("ENCY_PEDIA")
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
    //MARK: Encyclopedia API
    private func connection_encyclopedia_list() {
        
        sdLoader.startAnimating(atView: self.view)
        var parameter = [String: String]()
        parameter["request"] = "encyclopedia_list"
        
        APIManager.callAPIBYPOST(parameter: parameter, url: BASE_URL) { (response, status) in
            
            if status {
                let isResStatus = response["status"] as? String
                if isResStatus == "true" {
                    if let data = response["data"] as? NSArray {
                        self.encyclopediaModel = EncyclopediaModel.modelsFromDictionaryArray(array: data)
                        self.tblEncyclopedia.reloadData()
                        self.tblEncyclopedia.isHidden = false
                    }
                }
            }
            sdLoader.stopAnimation()
        }
    }
}



extension EncyclopediaListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.encyclopediaModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EncyclopediaCell
        let model = self.encyclopediaModel[indexPath.row]
        cell.delegate = self
        cell.configure_cell(tipsModel: model)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}

extension EncyclopediaListVC: ShareItemDelgate {
    
    func selectItemEncycopedia(encycopediaModel: EncyclopediaModel) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "TipsDetailVC") as! TipsDetailVC
        vc.getDetail = encycopediaModel.detail!
        vc.modalPresentationStyle = .overCurrentContext
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func selectItemShared(img: UIImage, msg: String) {
        shareActivity(img: img, msg: msg)
    }
    
    func shareActivity(img: UIImage, msg: String) {
        let image = img
        // set up activity view controller
        let activityViewController = UIActivityViewController(activityItems: [msg, image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
}
