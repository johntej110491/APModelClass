//
//  OtpVC.swift
//  DietApp
//
//  Created by user on 28/06/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

class OtpVC: UIViewController {

    @IBOutlet weak var txta:UITextField!
    @IBOutlet weak var txtb:UITextField!
    @IBOutlet weak var txtc:UITextField!
    @IBOutlet weak var txtd:UITextField!
    
    
    @IBOutlet weak var lblTitleVC: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnResend: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!

    var strOTP = String()

    var getEmail: String?
    var getIsForgot: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        txta.becomeFirstResponder()
        setting()
        // Do any additional setup after loading the view.
    }
    private func setting(){
        
        //Language setup
        let CurrentLanguage = UserDefaults_FindData(keyName: APP_LANGUAGE) as! String
        let isEnglishLang: Bool = CurrentLanguage == LanguageSetting.en.rawValue
        stackView.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft

        
        btnSubmit.setTitle(Localization("SUBMIT"), for: .normal)
        btnResend.setTitle(Localization("RESEND"), for: .normal)

        lblTitleVC.text = Localization("OTP_VC")
        lblMsg.text = Localization("OTP_MSG")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Action
    @IBAction func action_back(){
        navigationController?.popViewController(animated: true)
    }

    @IBAction func action_submit(){
        if isValidInfo() {
            if self.getIsForgot != nil {//forgot passwor
                connection_forgotPassword_otp()
            }else{//verify email
                connection_otp()
            }
        }
    }
    
    @IBAction func action_reSend(){
        connection_resendOTP()
    }
    
    
    // MARK: ---------Validation Method----------
    private func isValidInfo() -> Bool {
        
        if trim(str: txta.text!).count == 0 {
            iSSnackbarShow(message: "Please enter otp!")
            return false
        }
        
        if trim(str: txtb.text!).count == 0 {
            iSSnackbarShow(message: "Please enter otp!")
            return false
        }
        
        if trim(str: txtc.text!).count == 0 {
            iSSnackbarShow(message: "Please enter otp!")
            return false
        }
        
        if trim(str: txtd.text!).count == 0 {
            iSSnackbarShow(message: "Please enter otp!")
            return false
        }
  
        return true
    }
    
    
    func gotoOnHomeScreen()  {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let navigationController = NavigationController(rootViewController: viewController)
        let mainViewController = MainViewController()
        mainViewController.rootViewController = navigationController
        mainViewController.setup(type: UInt(2))
        appDelegate.window?.rootViewController = mainViewController
    }
    
    func gotoChangePassword() {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK:-
    //MARK: Login API
    private func connection_otp() {
        
        sdLoader.startAnimating(atView: self.view)
        self.view.endEditing(true)
        
        var parameter = [String: String]()
        parameter["request"] = "verify_email"
        parameter["user_email"] = self.getEmail
        parameter["otp"] = strOTP
        
        print(parameter)
        
        APIManager.callAPIBYPOST(parameter: parameter, url: BASE_URL) { (response, status) in
            print(response)
            
            if status {//API status 200
                if let isResStatus = response["status"]  {
                    if isResStatus as! String == "true" {
                        
                        let isActive = response["User_status"] as? String
                        if isActive == "Active" {//Verified
                            
                            if let resData = response["data"] {
                                userDataModel = UserDataMedel(dictionary: resData as! NSDictionary)
                                UserDefaults_SaveData(dictData: resData, keyName: UserData)
                            }
                            
                            self.gotoOnHomeScreen()
                        } else {//Not verified
                            if let msg = response["msg"] {
                                iSSnackbarShow(message: msg as! String)
                            }
                        }
                    }else{
                        if let msg = response["msg"] {
                            iSSnackbarShow(message: msg as! String)
                        }
                    }
                }
            }
            sdLoader.stopAnimation()
        }
    }
    
    //Forgot
    private func connection_forgotPassword_otp() {
        
        sdLoader.startAnimating(atView: self.view)
        self.view.endEditing(true)
        
        var parameter = [String: String]()
        parameter["request"] = "verify_otp"
        parameter["user_email"] = self.getEmail
        parameter["otp"] = strOTP
        
        print(parameter)
        
        APIManager.callAPIBYPOST(parameter: parameter, url: BASE_URL) { (response, status) in
            print(response)
            
            if status {//API status 200
                if let isResStatus = response["status"]  {
                    if isResStatus as! String == "true" {
                        if let resData = response["data"] {
                            userDataModel = UserDataMedel(dictionary: resData as! NSDictionary)
                        }
                        self.gotoChangePassword()
                        
                    }else{
                        if let msg = response["msg"] {
                            iSSnackbarShow(message: msg as! String)
                        }
                    }
                }
            }
            sdLoader.stopAnimation()
        }
    }
    
    private func connection_resendOTP() {
        
        sdLoader.startAnimating(atView: self.view)
        self.view.endEditing(true)
        
        var parameter = [String: String]()
        parameter["request"] = "resend_otp"
        parameter["user_email"] = self.getEmail
        print(parameter)
        
        APIManager.callAPIBYPOST(parameter: parameter, url: BASE_URL) { (response, status) in
            print(response)
            
            if status {//API status 200
                if let msg = response["msg"] {
                    iSSnackbarShow(message: msg as! String)
                }
            }
            sdLoader.stopAnimation()
        }
    }
}

    




//MARK: -
//MARK: UITextField Delegate
extension OtpVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentString: NSString = textField.text! as NSString
        //let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        if (currentString.length < 1  && string.count > 0){
            if(textField == self.txta){
                self.txtb.becomeFirstResponder()
            }
            if(textField == self.txtb){
                self.txtc.becomeFirstResponder()
            }
            if(textField == self.txtc){
                self.txtd.becomeFirstResponder()
            }
     
            textField.text = string
            strOTP += string
            print(strOTP)
            return false
            
        }else if ((textField.text?.count)! >= 1  && string.count == 0){
            // on deleting value from Textfield
       
            if(textField == self.txtd) {
                self.txtc.becomeFirstResponder()
            }
            if(textField == self.txtc) {
                self.txtb.becomeFirstResponder()
            }
            if(textField == self.txtb) {
                self.txta.becomeFirstResponder()
            }
            textField.text = ""
            strOTP=""
            return false
        }else if ((textField.text?.count)! >= 1  ){
            textField.text = string
            return false
        }
        return true
    }
}

