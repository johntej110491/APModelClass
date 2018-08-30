//
//  LoginVC.swift
//  DietApp
//
//  Created by user on 28/06/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var lblMsgTitle:UILabel!
    @IBOutlet weak var lblMsgEmail:UILabel!
    @IBOutlet weak var lblMsgPass:UILabel!
    @IBOutlet weak var btnForgotPass:UIButton!
    @IBOutlet weak var btnLogin:UIButton!
    @IBOutlet weak var btnSignup:UIButton!

    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var txtPasword:UITextField!
    @IBOutlet weak var lblVersion: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        settings()
    }
    
    private func settings(){
        
        let infoDict = Bundle.main.infoDictionary
        let doubleS = Double(infoDict!["CFBundleVersion"] as! String)
        let bundleVersion = "version \(doubleS!)"
        
        lblVersion.text = bundleVersion
        
        //self.view.semanticContentAttribute = .forceRightToLeft
        lblVersion.text = Localization("VERSION")
        lblMsgTitle.text = Localization("WELCOME")
        lblMsgEmail.text = Localization("EMAIL")
        lblMsgPass.text = Localization("PASSWORD")
        btnForgotPass.setTitle(Localization("FORGOT_PASS"), for: .normal)
        btnLogin.setTitle(Localization("LOGIN"), for: .normal)
        
        btnSignup.setAttributedTitle(NSAttributedString(string: Localization("SIGNUP")), for: .normal)
        lblVersion.attributedText = NSAttributedString(string: Localization("VERSION"))
        
        //Language setup
        let CurrentLanguage = UserDefaults_FindData(keyName: APP_LANGUAGE) as! String
        let isEnglishLang: Bool = CurrentLanguage == LanguageSetting.en.rawValue
        lblMsgEmail.textAlignment = isEnglishLang ? .left : .right
        lblMsgPass.textAlignment = isEnglishLang ? .left : .right
        txtEmail.textAlignment = isEnglishLang ? .left : .right
        txtPasword.textAlignment = isEnglishLang ? .left : .right
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtEmail.text = "payal@mailinator.com"
        txtPasword.text = "123456"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action
    @IBAction func action_registration(){
        let vc = mainStoryB.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func action_forgotPassward(sender:AnyObject){
        let ForgotPassword = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(ForgotPassword, animated: true)
    }
    
    @IBAction func action_login(sender:AnyObject){
         if isValidInfo()  {
            connection_login()
        }
    }
    
//    func api() {
//        APIManager.callAPIBYPOST(parameter: ["UserGUID": "e15db488-496f-0e5a-768f-3bcc95fae962", "SessionKey": "e675552d-5a6f-a061-e1f1-74254c38c690"], url: "http://expertteam.in/541-FitAtEase/api/sessions/getSessions") { (response, status) in
//            print("--------\(response)-------")
//        }
//    }
    
    // MARK: ---------Validation Method----------
    private func isValidInfo() -> Bool {
        
        guard trim(str: self.txtEmail.text!).count != 0 else {
            iSSnackbarShow(message: "Please enter email!")
            return false
        }
        if !isValidEmail(testStr: txtEmail!.text!) {
            iSSnackbarShow(message: "Please enter correct email id!")
            return false
        }
        
        //------------Email Address-------------
        guard trim(str: self.txtPasword.text!).count != 0 else {
            iSSnackbarShow(message: "Please enter password!")
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
    
    //MARK:-
    //MARK: Login API
    private func connection_login() {
        
        sdLoader.startAnimating(atView: self.view)
        self.view.endEditing(true)

        var parameter = [String: String]()
        parameter["request"] = "login"
        parameter["user_password"] = txtPasword.text!
        parameter["user_email"] = txtEmail.text
        parameter["user_device_type"] = "2"
        parameter["user_device_token"] = UserDefaults_FindData(keyName: APNS_TOKEN) as? String ?? DEFAULT_TOKEN
 
        print(parameter)
        
        APIManager.callAPIBYPOST(parameter: parameter, url: BASE_URL) { (response, status) in
            print(response)
            
            if status {
                if let isResStatus = response["status"]  {
                    if isResStatus as! String == "true" {
                        
                    let isActive = response["User_status"] as! String
                        if isActive == "Active" {//Verified
                            if let resData = response["userdata"] {
                                let dict = resData as! NSDictionary
                                userDataModel = UserDataMedel(dictionary: dict)
                                UserDefaults_SaveData(dictData: dict, keyName: UserData)
 //DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                self.gotoOnHomeScreen()
                             //   }
                            }
                            
                        }else{//Not verified
                            if let msg = response["msg"] {
                                self.alertOpen(msg: msg as! String)
                            }
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
            self.isNextOTP()
        }
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
extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
