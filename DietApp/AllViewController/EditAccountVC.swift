//
//  EditAccountVC.swift
//  DietApp
//
//  Created by user on 02/07/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit
import DropDown

class EditAccountVC: UIViewController {

    @IBOutlet weak var lblTitleVC     :UILabel!
    @IBOutlet weak var lblGenderMsg   :UILabel!
    @IBOutlet weak var lblFNameMsg    :UILabel!
    @IBOutlet weak var lblWeightMsg   :UILabel!
    @IBOutlet weak var lbllengthMsg   :UILabel!
    @IBOutlet weak var lblBTypeMsg    :UILabel!
    @IBOutlet weak var lblAgeMsg      :UILabel!
    @IBOutlet weak var lblHStatusMsg  :UILabel!

    @IBOutlet weak var txtWeight    :UITextField!
    @IBOutlet weak var txtFName    :UITextField!
    @IBOutlet weak var txtLength    :UITextField!
    @IBOutlet weak var txtAge       :UITextField!
    @IBOutlet weak var btnMale      :UIButton!
    @IBOutlet weak var btnFemale    :UIButton!
    @IBOutlet weak var btnBloodType :UIButton!
    @IBOutlet weak var btnHealthStatus:UIButton!
    @IBOutlet weak var txtOtherHStatus :UITextField!
    @IBOutlet weak var viewHeader: UIView!

    @IBOutlet weak var scrollView   :UIScrollView!
    @IBOutlet weak var btnUpdate:UIButton!
    @IBOutlet weak var btnLang:UIButton!

    @IBOutlet weak var constant_healthStatus_height: NSLayoutConstraint!

    //DropDown
    let bloodTypeDropDown = DropDown()
    let healthStatusDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [self.bloodTypeDropDown,self.healthStatusDropDown]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setting()
    }
    
    private func setting(){
        
        lblTitleVC.text = Localization("MY_ACCOUNT")
        lblGenderMsg.text = Localization("GENDER")
        lblFNameMsg.text = Localization("FNAME")
        lblWeightMsg.text = Localization("WEIGHT")
        lbllengthMsg.text = Localization("LENGTH")
        lblAgeMsg.text = Localization("AGE")
        lblHStatusMsg.text = Localization("HEALTH_STATUS")
        lblBTypeMsg.text = Localization("B_TYPE")

        btnMale.setTitle(Localization("MALE"), for: .normal)
        btnFemale.setTitle(Localization("FEMALE"), for: .normal)
        btnUpdate.setTitle(Localization("UPDATE"), for: .normal)

        let CurrentLanguage = UserDefaults_FindData(keyName: APP_LANGUAGE) as! String
        let isEnglishLang: Bool = CurrentLanguage == LanguageSetting.en.rawValue
        scrollView.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft

        viewHeader.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft

        txtFName.textAlignment = isEnglishLang ? .left : .right
        txtWeight.textAlignment = isEnglishLang ? .left : .right
        txtAge.textAlignment = isEnglishLang ? .left : .right
        txtLength.textAlignment = isEnglishLang ? .left : .right
        txtOtherHStatus.textAlignment = isEnglishLang ? .left : .right
        
        lblGenderMsg.textAlignment = isEnglishLang ? .left : .right
        lblFNameMsg.textAlignment = isEnglishLang ? .left : .right
        lblWeightMsg.textAlignment = isEnglishLang ? .left : .right
        lbllengthMsg.textAlignment = isEnglishLang ? .left : .right
        lblBTypeMsg.textAlignment = isEnglishLang ? .left : .right
        lblAgeMsg.textAlignment = isEnglishLang ? .left : .right
        lblHStatusMsg.textAlignment = isEnglishLang ? .left : .right
        
        if let topView = self.scrollView.viewWithTag(11) { topView.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft}
        
        if let topView = self.scrollView.viewWithTag(12) {topView.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft}
        
            btnBloodType.contentHorizontalAlignment = isEnglishLang ? .left : .right
            btnHealthStatus.contentHorizontalAlignment = isEnglishLang ? .left : .right
        
        //Gender
        btnMale.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft
        btnFemale.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft
        btnMale.contentHorizontalAlignment = isEnglishLang ? .left : .right
        btnFemale.contentHorizontalAlignment = isEnglishLang ? .left : .right
        let a:CGFloat =  isEnglishLang ? 10 : -10
        let b:CGFloat = isEnglishLang ? -10 : 10
        btnMale.titleEdgeInsets = UIEdgeInsetsMake(0, a, 0, b)
        btnFemale.titleEdgeInsets = UIEdgeInsetsMake(0, a, 0, b)
        btnLang.contentHorizontalAlignment = isEnglishLang ? .right : .left
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollView.contentSize = CGSize(width: 0, height: self.btnUpdate.frame.origin.y + 100)
        setupHealthStatusDropDown()
        setupBloodTypeDropDownDropDown()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadData(){
        if (userDataModel != nil) {
            let gender = userDataModel?.user_gender
            self.action_gender(sender: gender == "Male" ? btnMale : btnFemale)
            btnBloodType.setTitle(userDataModel?.blood_group, for: .normal)
            txtAge.text = userDataModel?.age
            txtLength.text = userDataModel?.height
            txtWeight.text = userDataModel?.weight
            txtFName.text = userDataModel?.user_name

            if (userDataModel?.health_status?.contains(","))! {
                btnHealthStatus.setTitle("Other diseases", for: .normal)
                self.constant_healthStatus_height.constant = 40
                txtOtherHStatus.text = userDataModel?.health_status

            }else{
                txtOtherHStatus.text = ""
                btnHealthStatus.setTitle(userDataModel?.health_status, for: .normal)
                self.constant_healthStatus_height.constant = 0
            }
            
        }
    }
    
    
    fileprivate func setupBloodTypeDropDownDropDown() {
        
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        
        bloodTypeDropDown.anchorView = btnBloodType
        bloodTypeDropDown.width = btnBloodType.frame.size.width
        // You can also use localizationKeysDataSource instead. Check the docs.
        bloodTypeDropDown.dataSource = ["O−", "O+", "A−", "A+", "B−", "B+", "AB−", "AB+"]
        
        let appearance = DropDown.appearance()
        appearance.cellHeight = 40
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = .clear
        appearance.separatorColor = .clear
        appearance.animationduration = 0.25
        appearance.textColor =  .black
        
        dropDowns.forEach {
            $0.cellNib = UINib(nibName: "DropDownCell", bundle: Bundle(for: DropDownCell.self))
            $0.customCellConfiguration = nil
            
        }
        
        // Action triggered on selection
        bloodTypeDropDown.selectionAction = { [unowned self] (index, item) in
            self.btnBloodType.setTitle(item, for: .normal)
        }
    }
    
    
    fileprivate func setupHealthStatusDropDown() {
        
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        
        healthStatusDropDown.anchorView = btnHealthStatus
        healthStatusDropDown.width = btnHealthStatus.frame.size.width
        // You can also use localizationKeysDataSource instead. Check the docs.
        healthStatusDropDown.dataSource = ARY_HEALTH_STATUS
        
        let appearance = DropDown.appearance()
        appearance.cellHeight = 40
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = .clear
        appearance.separatorColor = .clear
        appearance.animationduration = 0.25
        appearance.textColor =  .black
        
        dropDowns.forEach {
            $0.cellNib = UINib(nibName: "DropDownCell", bundle: Bundle(for: DropDownCell.self))
            $0.customCellConfiguration = nil
        }
        
        // Action triggered on selection
        healthStatusDropDown.selectionAction = { [unowned self] (index, item) in
            self.btnHealthStatus.setTitle(item, for: .normal)
            if index == 6 {
                self.constant_healthStatus_height.constant = 40
            }else{
                self.constant_healthStatus_height.constant = 0
            }
            self.scrollView.contentSize = CGSize(width: 0, height: self.btnUpdate.frame.origin.y + 100)
        }
    }
    
    // MARK: - Action
    @IBAction func action_gender(sender: UIButton){
        if sender.tag == 0 {
            self.btnFemale.setImage(#imageLiteral(resourceName: "radio_inactive"), for: .normal)
            self.btnMale.setImage(#imageLiteral(resourceName: "radio_active"), for: .normal)
        }else{
            self.btnMale.setImage(#imageLiteral(resourceName: "radio_inactive"), for: .normal)
            self.btnFemale.setImage(#imageLiteral(resourceName: "radio_active"), for: .normal)
        }
    }
    
    @IBAction func action_back(){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_updateProfile(){
        if isValidInfo() {
            connection_updateProfile()
        }
    }
    
    @IBAction func action_bloodType(){
        bloodTypeDropDown.show()
    }
    
    @IBAction func action_healthStatus(){
        healthStatusDropDown.show()
    }
    
    @IBAction func action_logout(){
        isLOgout()
    }
    
    @IBAction func action_changeLanguage(){
        isChangeLanguage()
    }
    
    func isLOgout(){
        
        let alertController = UIAlertController(title: Localization("LOGOUT"), message: Localization("LOGOUT_MSG"), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Localization("NO"), style: .cancel)
        let okAction = UIAlertAction(title: Localization("YES"), style: .default) { (action:UIAlertAction!) in
            self.dismiss(animated: false, completion: nil)
            
            let token = UserDefaults_FindData(keyName: APNS_TOKEN)
            let strLanguage = UserDefaults_FindData(keyName: APP_LANGUAGE) as! String

            print("----\(token)----")

            if let appDomain = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: appDomain)
                //UserDefaults.standard.persistentDomain(forName: appDomain)
            }
            print("----\(token)----")
            
            UserDefaults_SaveData(dictData: token, keyName: APNS_TOKEN)
            UserDefaults_SaveData(dictData: strLanguage, keyName: APP_LANGUAGE)
            appDelegate.languageSetUp()

            let vc = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let navigationController = UINavigationController(rootViewController: vc)
            appDelegate.window?.rootViewController = navigationController
            appDelegate.window?.makeKeyAndVisible()
            navigationController.setNavigationBarHidden(true, animated: false);
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isChangeLanguage(){
        
        let alertController = UIAlertController(title: Localization("LANGUAGE"), message: Localization("LANGUAGE_MSG"), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Localization("CANCEL"), style: .cancel)
        
        let englishAction = UIAlertAction(title: Localization("ENGLISH"), style: .default) { (action:UIAlertAction!) in
            self.switchLanguage(language: .en)
        }
        let arebicAction = UIAlertAction(title: Localization("AREBIC"), style: .default) { (action:UIAlertAction!) in
            self.switchLanguage(language: .ar)
        }

        alertController.addAction(englishAction)
        alertController.addAction(arebicAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func switchLanguage(language: LanguageSetting) {
        
        if language == .en {//English
            UserDefaults_SaveData(dictData: "\(LanguageSetting.en)", keyName: APP_LANGUAGE)

        }else{//Arebic
            UserDefaults_SaveData(dictData: "\(LanguageSetting.ar)", keyName: APP_LANGUAGE)
        }
        
        appDelegate.languageSetUp()
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        viewController.isRootNotification = false
        let navigationController = NavigationController(rootViewController: viewController)
        let mainViewController = MainViewController()
        mainViewController.rootViewController = navigationController
        mainViewController.setup(type: UInt(2))
        appDelegate.window?.rootViewController = mainViewController
    }
    
    
    // MARK: ---------Validation Method----------
    var strHealthStatus = String()

    private func isValidInfo() -> Bool {
        
        //------------Weight-------------
        if trim(str: txtFName.text!).count == 0 {
            iSSnackbarShow(message: "Please enter full name!")
            return false
        }
        
        //------------Weight-------------
        if trim(str: txtWeight.text!).count == 0 {
            iSSnackbarShow(message: "Please enter weight!")
            return false
        }
        
        //------------Length-------------
        if trim(str: txtLength.text!).count == 0 {
            iSSnackbarShow(message: "Please enter length!")
            return false
        }
        
        //------------BloodType-------------
        if trim(str: (btnBloodType.titleLabel?.text!)!).count == 0 {
            iSSnackbarShow(message: "Please select blood type")
            return false
        }
        
        //------------Age-------------
        if trim(str: txtAge.text!).count == 0 {
            iSSnackbarShow(message: "Please enter age!")
            return false
        }
        //------------Health status-------------
        if trim(str: (btnHealthStatus.titleLabel?.text!)!).count == 0 {
            iSSnackbarShow(message: "Please select health status")
            return false
        }else{
            strHealthStatus = (btnHealthStatus.titleLabel?.text!)!
            if btnHealthStatus.titleLabel?.text! == "Other diseases" {
                if trim(str: txtOtherHStatus.text!).count == 0 {
                    iSSnackbarShow(message: "Please enter other health status")
                    return false
                }
                strHealthStatus = txtOtherHStatus.text!
            }
        }

        return true
    }
    
    
    
    private func connection_updateProfile() {
        self.view.endEditing(true)
        
        sdLoader.startAnimating(atView: self.view)
        var parameter = [String: String]()
        parameter["request"] = "update_profile"
        parameter["user_name"] = self.txtFName.text!
        parameter["user_id"] = userDataModel?.user_id
        parameter["blood_group"] = btnBloodType.titleLabel?.text!
        parameter["user_gender"] = (btnMale.imageView?.image == #imageLiteral(resourceName: "radio_active") ) ? "Male" : "Female"
        parameter["age"] = txtAge.text!
        parameter["weight"] = txtWeight.text!
        parameter["height"] = txtLength.text!
        parameter["health_status"] = strHealthStatus
        print(parameter)
        
        APIManager.callAPIBYPOST(parameter: parameter, url: BASE_URL) { (response, status) in
            print(response)
            
            if status {
                if let isResStatus = response["status"]  {
                    if isResStatus as! String == "true" {
                        
                        if let resData = response["response"] {
                            userDataModel = UserDataMedel(dictionary: resData as! NSDictionary)
                            UserDefaults_SaveData(dictData: resData, keyName: UserData)
                        }
                        
                        if let msg = response["msg"] {
                            self.alertOpen(msg: msg as! String)
                        }
                    }else{
                        if let msg = response["msg"] {
                            iSSnackbarShow(message: msg as! String)
                        }
                    }
                }
                
            }else{
                if let msg = response["msg"] {
                    iSSnackbarShow(message: msg as! String)
                }
            }
            sdLoader.stopAnimation()
        }
    }
    fileprivate func alertOpen(msg: String) {
        let alertController = UIAlertController(title: "DietApp", message: msg, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
           self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
}
