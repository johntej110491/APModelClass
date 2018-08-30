//
//  ForgotPasswordVC.swift
//  DietApp
//
//  Created by user on 28/06/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var lblTitleVC: UILabel!
    @IBOutlet weak var lblMSG: UILabel!
    @IBOutlet weak var lblEmailMsg: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()

        // Do any additional setup after loading the view.
    }
    private func setting(){
        
        //Language setup
        let CurrentLanguage = UserDefaults_FindData(keyName: APP_LANGUAGE) as! String
        let isEnglishLang: Bool = CurrentLanguage == LanguageSetting.en.rawValue
        
        lblEmailMsg.textAlignment = isEnglishLang ? .left : .right
        txtEmail.textAlignment = isEnglishLang ? .left : .right

        btnSubmit.setTitle(Localization("SUBMIT"), for: .normal)
        lblTitleVC.text = Localization("FORGOT_PASS")
        lblEmailMsg.text = Localization("EMAIL")
        lblMSG.text = Localization("FORGOT_PASSWORD_MSG")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Action
    @IBAction func action_back(){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_submit(sender:AnyObject){
        
        guard trim(str: self.txtEmail.text!).count != 0 else {
            iSSnackbarShow(message: "Please enter email!")
            return
        }
        if !isValidEmail(testStr: txtEmail!.text!) {
            iSSnackbarShow(message: "Please enter correct email id!")
            return
        }
        connection_forgot_password()
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
        vc.getIsForgot = true
        navigationController?.pushViewController(vc, animated: true)
    }
    //MARK:-
    //MARK: Login API
    private func connection_forgot_password() {
        
        sdLoader.startAnimating(atView: self.view)
        self.view.endEditing(true)
        
        var parameter = [String: String]()
        parameter["request"] = "forget_password"
        parameter["user_email"] = txtEmail.text

       // print(parameter)
        
        APIManager.callAPIBYPOST(parameter: parameter, url: BASE_URL) { (response, status) in
            print(response)
            
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
    
    
}
