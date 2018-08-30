//
//  ChangePasswordVC.swift
//  DietApp
//
//  Created by user on 28/06/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var txtPass      :UITextField!
    @IBOutlet weak var txtConfPass  :UITextField!
    
    var getEmail: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        if isValidInfo() {
            connection_reset_password()
        }
    }
    
    // MARK: ---------Validation Method----------
    private func isValidInfo() -> Bool {
        
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
    
    //MARK:-
    //MARK: Login API
    private func connection_reset_password() {
        
        sdLoader.startAnimating(atView: self.view)
        self.view.endEditing(true)
        
        var parameter = [String: String]()
        parameter["request"] = "create_new_password"
        parameter["user_email"] = userDataModel?.user_email
        parameter["new_password"] = self.txtPass.text!

        print(parameter)
        
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
    
    fileprivate func alertOpen(msg: String) {
        let alertController = UIAlertController(title: "DietApp", message: msg, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
