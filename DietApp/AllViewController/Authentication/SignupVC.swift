//
//  SignupVC.swift
//  DietApp
//
//  Created by user on 28/06/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit
import DropDown

class SignupVC: UIViewController {

    @IBOutlet weak var scrollView   :UIScrollView!
    @IBOutlet weak var txtFName     :UITextField!
    @IBOutlet weak var txtEmail     :UITextField!
    @IBOutlet weak var txtWeight    :UITextField!
    @IBOutlet weak var txtLength    :UITextField!
    @IBOutlet weak var txtAge       :UITextField!
    @IBOutlet weak var txtPass      :UITextField!
    @IBOutlet weak var txtOtherHStatus :UITextField!
    @IBOutlet weak var txtConfPass  :UITextField!
    @IBOutlet weak var btnMale      :UIButton!
    @IBOutlet weak var btnFemale    :UIButton!
    @IBOutlet weak var btnBloodType :UIButton!
    @IBOutlet weak var btnHealthStatus:UIButton!
    @IBOutlet weak var btnLogin     :UIButton!
    @IBOutlet weak var btnRegister     :UIButton!

    
    @IBOutlet weak var lblEmailMsg   :UILabel!
    @IBOutlet weak var lblGenderMsg   :UILabel!
    @IBOutlet weak var lblFNameMsg    :UILabel!
    @IBOutlet weak var lblWeightMsg   :UILabel!
    @IBOutlet weak var lbllengthMsg   :UILabel!
    @IBOutlet weak var lblBTypeMsg    :UILabel!
    @IBOutlet weak var lblAgeMsg      :UILabel!
    @IBOutlet weak var lblHStatusMsg  :UILabel!
    @IBOutlet weak var lblHPassMsg    :UILabel!
    @IBOutlet weak var lblHConfPassMsg  :UILabel!

    
    

    @IBOutlet weak var constant_healthStatus_height: NSLayoutConstraint!
    @IBOutlet weak var constant_healthStatus_top: NSLayoutConstraint!
    
    //DropDown
    let bloodTypeDropDown = DropDown()
    let healthStatusDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [self.bloodTypeDropDown,self.healthStatusDropDown]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings()
        constant_healthStatus_top.constant = 0
        constant_healthStatus_height.constant = 0
        // Do any additional setup after loading the view.
    }
    private func settings(){

        
        lblEmailMsg.text = Localization("EMAIL")
        lblGenderMsg.text = Localization("GENDER")
        lblFNameMsg.text = Localization("FNAME")
        lblWeightMsg.text = Localization("WEIGHT")
        lbllengthMsg.text = Localization("LENGTH")
        lblAgeMsg.text = Localization("AGE")
        lblHStatusMsg.text = Localization("HEALTH_STATUS")
        lblBTypeMsg.text = Localization("B_TYPE")
        lblHPassMsg.text = Localization("PASSWORD")
        lblHConfPassMsg.text = Localization("CONF_PASSWORD")
        btnMale.setTitle(Localization("MALE"), for: .normal)
        btnFemale.setTitle(Localization("FEMALE"), for: .normal)
        btnRegister.setTitle(Localization("REGISTER"), for: .normal)
        btnLogin.setAttributedTitle(NSAttributedString(string: Localization("ALREADY_LOGIN")), for: .normal)

       

        //Language setup
        let CurrentLanguage = UserDefaults_FindData(keyName: APP_LANGUAGE) as! String
        let isEnglishLang: Bool = CurrentLanguage == LanguageSetting.en.rawValue
        
        
        lblEmailMsg.textAlignment = isEnglishLang ? .left : .right
        lblGenderMsg.textAlignment = isEnglishLang ? .left : .right
        lblFNameMsg.textAlignment = isEnglishLang ? .left : .right
        lblWeightMsg.textAlignment = isEnglishLang ? .left : .right
        lbllengthMsg.textAlignment = isEnglishLang ? .left : .right
        lblBTypeMsg.textAlignment = isEnglishLang ? .left : .right
        lblAgeMsg.textAlignment = isEnglishLang ? .left : .right
        lblHStatusMsg.textAlignment = isEnglishLang ? .left : .right
        lblHPassMsg.textAlignment = isEnglishLang ? .left : .right
        lblHConfPassMsg.textAlignment = isEnglishLang ? .left : .right

        
        txtFName.textAlignment = isEnglishLang ? .left : .right
        txtEmail.textAlignment = isEnglishLang ? .left : .right
        txtWeight.textAlignment = isEnglishLang ? .left : .right
        txtLength.textAlignment = isEnglishLang ? .left : .right
        txtPass.textAlignment = isEnglishLang ? .left : .right
        txtConfPass.textAlignment = isEnglishLang ? .left : .right
        txtOtherHStatus.textAlignment = isEnglishLang ? .left : .right

        scrollView.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft


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

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: 0, height: 1000)
        setupHealthStatusDropDown()
        setupBloodTypeDropDownDropDown()
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
                self.constant_healthStatus_top.constant = 12
                self.constant_healthStatus_height.constant = 40
            }else{
                self.constant_healthStatus_top.constant = 0
                self.constant_healthStatus_height.constant = 0
            }
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
    
    @IBAction func action_login(){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_registration(){
        if isValidInfo() {
            connection_signup()
        }
    }

    @IBAction func action_bloodType(){
        bloodTypeDropDown.show()
    }
    
    @IBAction func action_healthStatus(){
        healthStatusDropDown.show()
    }
    
    // MARK: ---------Validation Method----------
    var strHealthStatus = String()
    private func isValidInfo() -> Bool {
        
        //------------FullName-------------
        if trim(str: txtFName.text!).count == 0 {
            iSSnackbarShow(message: "Please enter name!")
            return false
        }
        
        //------------Email Address-------------
        guard trim(str: self.txtEmail.text!).count != 0 else {
            iSSnackbarShow(message: "Please enter email!")
            return false
        }
        if !isValidEmail(testStr: txtEmail!.text!) {
            iSSnackbarShow(message: "Please enter correct email id!")
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
        
        //------------Password-------------
        if trim(str: txtPass.text!).count == 0{
            iSSnackbarShow(message: "Please enter password!")
            return false
        }
        
        if trim(str: txtPass.text!).count < 6{
            iSSnackbarShow(message: "Password should be minimum 6 characters!")
            return false
        }
        
        //------------Confirm Password-------------
        if trim(str: txtConfPass.text!).count == 0{
            iSSnackbarShow(message: "Please enter confirm password!")
            return false
        }
        
        if  txtConfPass.text !=  txtPass.text {
            iSSnackbarShow(message: "Password mismatch")
            return false
        }
        
        return true
    }
    
    private func connection_signup() {
        self.view.endEditing(true)
        
        sdLoader.startAnimating(atView: self.view)
        var parameter = [String: String]()
        parameter["request"] = "user_signup"
        parameter["user_name"] = txtFName.text!
        parameter["user_email"] = txtEmail.text
        parameter["user_device_type"] = "2"
        parameter["user_device_token"] = UserDefaults_FindData(keyName: APNS_TOKEN) as? String ?? DEFAULT_TOKEN
        parameter["user_type"] = "2"
        parameter["user_password"] = txtPass.text!
        parameter["blood_group"] = btnBloodType.titleLabel?.text!
        parameter["gender"] = (btnMale.imageView?.image == #imageLiteral(resourceName: "radio_active")) ? "Male" : "Female"
        parameter["age"] = txtAge.text!
        parameter["weight"] = txtWeight.text!
        parameter["height"] = txtLength.text!
        parameter["health_status"] = strHealthStatus
        //print(parameter)
        
        APIManager.callAPIBYPOST(parameter: parameter, url: BASE_URL) { (response, status) in
            //print(response)

            if status {
                if let isResStatus = response["status"]  {
                    if isResStatus as! String == "true" {
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
            self.isNextOTP()}
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isNextOTP() {
        let vc = mainStoryB.instantiateViewController(withIdentifier: "OtpVC") as! OtpVC
        vc.getEmail = self.txtEmail.text!
        navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: -
//MARK: UITextField Delegate
extension SignupVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
