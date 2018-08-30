//
//  HomeVC.swift
//  DietApp
//
//  Created by user on 28/06/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var btnDate: UIButton!
    
    @IBOutlet weak var lblExpert: UILabel!
    @IBOutlet weak var lblTitleVC: UILabel!
    @IBOutlet weak var lblCalMsg: UILabel!

    @IBOutlet weak var lblSCounter: UILabel!
    @IBOutlet weak var lblRWater: UILabel!
    @IBOutlet weak var lblBFat: UILabel!
    @IBOutlet weak var lblFCalories: UILabel!
    @IBOutlet weak var lblDTips: UILabel!
    @IBOutlet weak var lblEncyclo: UILabel!
    @IBOutlet weak var lblWhatsapp: UILabel!
    @IBOutlet weak var btnFB: UIButton!
    @IBOutlet weak var btnLinkIn: UIButton!
    @IBOutlet weak var btnTwitter: UIButton!
    @IBOutlet weak var btnGPlus: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblCalories: UILabel!
    @IBOutlet weak var viewHeader: UIView!

    var arySocialData = NSArray()
    
    var isRootNotification = Bool()
    override func viewDidLoad() {
        
        sideMenuController?.isLeftViewSwipeGestureEnabled = false
        super.viewDidLoad()
        setting()
        connection_socialLink()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
        scrollView.contentSize = CGSize(width: 0, height: 650)
        lblCalories.text =  "\(findCalories())"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setting(){
    
        lblCalories.layer.cornerRadius = 10
        lblCalories.layer.masksToBounds = true
        
        let dateFormate = DateFormatter()
        dateFormate.dateStyle = .medium
        var strDate = dateFormate.string(from: Date())
        strDate = strDate.replacingOccurrences(of: "-", with: " ")
        btnDate.setTitle("  \(strDate)", for: .normal)
        
        if isRootNotification {
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "RecommendedWaterVC") as! RecommendedWaterVC
            navigationController?.pushViewController(vc, animated: true)
        }
    
        lblTitleVC.text = Localization("DASHBOARD")
        lblCalMsg.text = Localization("CAL_MSG")
        lblBFat.text = Localization("BODY_FAT")
        lblFCalories.text = Localization("FOOD_CALORIES")
        lblExpert.text = Localization("EXPERT_ADVICE")
        lblDTips.text = Localization("DAILY_TIPS")
        lblEncyclo.text = Localization("ENCY_PEDIA")
        lblWhatsapp.text = Localization("WHATSAPP_GROUP")
        lblSCounter.text = Localization("STESP_COUNTER")
        lblRWater.text = Localization("RECOMMEN_WATER")



 
        //Language setup
 
        let CurrentLanguage = UserDefaults_FindData(keyName: APP_LANGUAGE) as! String
        let isEnglishLang: Bool = CurrentLanguage == LanguageSetting.en.rawValue
        scrollView.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft
    
        if let topView = self.scrollView.viewWithTag(11) { topView.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft}
    
        if let topView = self.scrollView.viewWithTag(12) {topView.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft}
        btnDate.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft
        btnDate.contentHorizontalAlignment = isEnglishLang ? .left : .right
        viewHeader.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft
        
    
        let a:CGFloat =  isEnglishLang ? 7 : -7
        let b:CGFloat = isEnglishLang ? -7 : 7
        btnDate.titleEdgeInsets = UIEdgeInsetsMake(0, a, 0, b)
        
    }
    
    
    func findCalories()->Double {
        
        var intakeCalorie: Double = 0.0
        let iWeight = Double("\(userDataModel?.weight ?? "")")
        let iLength = Double("\(userDataModel?.height ?? "")")

        if let age = userDataModel?.age {
            let age1 = NSInteger(age)!
            
            if userDataModel?.user_gender == "Male" {
                
                let ww: Double = (13.7 * iWeight!)
                let ll: Double = (5 * iLength!)
                let aa: Double = (6.8 * Double(age1))
                intakeCalorie = 66 + ww + ll - aa;
                
            }else{//Female
                let ww: Double = (9.6 * iWeight!)
                let ll: Double = (1.8 * iLength!)
                let aa: Double = (4.7 * Double(age1))
                intakeCalorie = 655 + ww + ll - aa;
            }
        }
        let rr = Double(round(intakeCalorie*10/10))
        return rr
    }

    //MARK: Action
    //MARK: -
    @IBAction func action_menu(_ sender : UIButton){
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    
    @IBAction func action_stepCounter(_ sender : UIButton){
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "CaloriesCounterVC") as! CaloriesCounterVC
        vc.isGetCalories = lblCalories.text!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func action_watsapp(_ sender : UIButton){
        let whatsappUrl = URL(string: strWhatsAppURL)
        if UIApplication.shared.canOpenURL(whatsappUrl! as URL) {
            UIApplication.shared.open(whatsappUrl!)
        } else {
            //redirect to safari because the user doesn't have Instagram
            print("App not installed")
            UIApplication.shared.open(URL(string: "https://itunes.apple.com/in/app/whatsapp-messenger/id310633997?mt=8")!)
        }
    }

    @IBAction func action_social(_ sender : UIButton){

        switch sender.tag {
        case 0:
            openURLScheme(schemeURL: findLinkURL(linkKey: "Facebook"))
            break

        case 1:
            openURLScheme(schemeURL: findLinkURL(linkKey: "Google"))
            break
           
        case 2:
            openURLScheme(schemeURL: findLinkURL(linkKey: "Twitter"))
            break
            
        case 3:
            openURLScheme(schemeURL: findLinkURL(linkKey: "LinkedIn"))
            break
            
        default:
            break
        }
    }
    
    //MARK:-
    //MARK: Get Social link
    var strWhatsAppURL = String()
    private func connection_socialLink() {

        sdLoader.startAnimating(atView: self.view)
        self.view.endEditing(true)
        
        var parameter = [String: String]()
        parameter["request"] = "Links"
        parameter["user_id"] = userDataModel?.user_id
        
        print(parameter)
        APIManager.callAPIBYPOST(parameter: parameter, url: BASE_URL) { (response, status) in
            print(response)
            
            if status {
            let isResStatus = response["status"] as? String
                if isResStatus == "true" {
                    
                    if let number = response["expert"] as? String {
                        appDelegate.getExpertNumber = number
                    }
                    if let url = response["whatsAppGroup"] as? String {
                        self.strWhatsAppURL = url
                    }
                    
                    if let data = response["data"] as? NSArray {
                        self.arySocialData = data
                        self.loadData(data: data )
                    }
                }
            }
            sdLoader.stopAnimation()
        }
    }
    
    
    private func loadData(data: NSArray) {
     
        for obj in data {
            let strItem = (obj as! NSDictionary).value(forKey: "name") as! String
            
            switch strItem {
            case "Twitter" :
                btnTwitter.isHidden = false
                break
            
            case "Google" :
                btnGPlus.isHidden = false
                break
                
            case "Facebook" :
                btnFB.isHidden = false
                break
                
            case "LinkedIn" :
                btnLinkIn.isHidden = false
                break
                
            default:
                break
            }
        }
    }
    
    
    private func findLinkURL(linkKey: String) -> String {
        for obj in self.arySocialData {
            let strItem = (obj as! NSDictionary).value(forKey: "name") as! String
            if strItem == linkKey {
                let url = (obj as! NSDictionary).value(forKey: "address") as! String
                return url
            }
        }
        return ""
    }
}
