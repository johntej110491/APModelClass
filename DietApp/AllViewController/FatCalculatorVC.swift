//
//  FatCalculatorVC.swift
//  DietApp
//
//  Created by user on 03/07/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

class FatCalculatorVC: UIViewController {
    
 
    @IBOutlet weak var btnCalcu     :UIButton!

    @IBOutlet weak var txtWristMesu    :UITextField!
    @IBOutlet weak var txtWaistMesu    :UITextField!
    @IBOutlet weak var txtHipMesu      :UITextField!
    @IBOutlet weak var txtForearnMesu  :UITextField!
    @IBOutlet weak var scrollView   :UIScrollView!
    
    @IBOutlet weak var lblTitleVC          :UILabel!
    @IBOutlet weak var lblWristMesuMsg     :UILabel!
    @IBOutlet weak var lblWaistMesuMsg     :UILabel!
    @IBOutlet weak var lblHipMesuMsg       :UILabel!
    @IBOutlet weak var lblForearnMesuMsg   :UILabel!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setting()
    }
    
    private func setting(){
        
        
        let isMale = userDataModel?.user_gender == "Male"
    
        lblWristMesuMsg.isHidden = isMale ? true : false
        lblWaistMesuMsg.isHidden = isMale ? false : false
        lblHipMesuMsg.isHidden = isMale ? true : false
        lblForearnMesuMsg.isHidden = isMale ? true : false

        let view1 = scrollView.viewWithTag(1)
        let view2 = scrollView.viewWithTag(2)
        let view3 = scrollView.viewWithTag(3)
        let view4 = scrollView.viewWithTag(4)
        view1?.isHidden = isMale ? true : false
        view2?.isHidden = isMale ? false : false
        view3?.isHidden = isMale ? true : false
        view4?.isHidden = isMale ? true : false
        
        lblTitleVC.text = Localization("BODY_FAT")
        lblWristMesuMsg.text = Localization("WRIST_MESURMENT")
        lblWaistMesuMsg.text = Localization("WAIST_MESURMENT")
        lblHipMesuMsg.text = Localization("HIP_MESURMENT")
        lblForearnMesuMsg.text = Localization("FOREARN_MESURMENT")
 
        btnCalcu.setTitle(Localization("CALCULATE"), for: .normal)
        
        let CurrentLanguage = UserDefaults_FindData(keyName: APP_LANGUAGE) as! String
        let isEnglishLang: Bool = CurrentLanguage == LanguageSetting.en.rawValue
        scrollView.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft
        
        let viewHeader = self.view.viewWithTag(11)
        viewHeader?.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft
        
        txtWristMesu.textAlignment = isEnglishLang ? .left : .right
        txtWaistMesu.textAlignment = isEnglishLang ? .left : .right
        txtHipMesu.textAlignment = isEnglishLang ? .left : .right
        txtForearnMesu.textAlignment = isEnglishLang ? .left : .right

        lblWristMesuMsg.textAlignment = isEnglishLang ? .left : .right
        lblWaistMesuMsg.textAlignment = isEnglishLang ? .left : .right
        lblHipMesuMsg.textAlignment = isEnglishLang ? .left : .right
        lblForearnMesuMsg.textAlignment = isEnglishLang ? .left : .right
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: 0, height: 603)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action
    @IBAction func action_back(){
        navigationController?.popViewController(animated: true)
    }
    
 
    
    @IBAction func action_calculate() {
        
        self.view.endEditing(true)
        
        let isMale = userDataModel?.user_gender == "Male"

        if isMale {
            if isMaleValidInfo(){
                let vc = mainStoryB.instantiateViewController(withIdentifier: "FatResultVC") as! FatResultVC
                vc.modalPresentationStyle = .overCurrentContext
                vc.getFatRatio =  maleCalculation()
                vc.getGender = "Male"
                navigationController?.present(vc, animated: true, completion: nil)
            }
            
        }else{
            
            if isFemaleValidInfo(){
                let vc = mainStoryB.instantiateViewController(withIdentifier: "FatResultVC") as! FatResultVC
                vc.modalPresentationStyle = .overCurrentContext
                vc.getFatRatio =  femaleCalculation()
                vc.getGender = "Female"
                navigationController?.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: ---------Validation Method(Male)----------
    private func isMaleValidInfo() -> Bool {
        //------------Waist-------------
        if trim(str: txtWaistMesu.text!).count == 0 {
            iSSnackbarShow(message: "Please enter waist measurement!")
            return false
        }
        return true
    }
    
    // MARK: ---------Validation Method(Female)----------
    private func isFemaleValidInfo() -> Bool {
        
        //------------Wrist-------------
        if trim(str: txtWristMesu.text!).count == 0 {
            iSSnackbarShow(message: "Please enter wrist measurement!")
            return false
        }
        //------------Waist-------------
        if trim(str: txtWaistMesu.text!).count == 0 {
            iSSnackbarShow(message: "Please enter waist measurement!")
            return false
        }
        //------------Hip-------------
        if trim(str: txtHipMesu.text!).count == 0 {
            iSSnackbarShow(message: "Please enter hip measurement!")
            return false
        }
        //------------forearn------------
        if trim(str: txtForearnMesu.text!).count == 0 {
            iSSnackbarShow(message: "Please enter forearn measurement!")
            return false
        }
   
        return true
    }
    
    
    private func maleCalculation()->Double{
     
        var waist_measurement: Double = 0.0

        let iWeight = Double("\(userDataModel?.weight ?? "")")
        if let doubleValue = Double(self.txtWaistMesu.text!) {
            waist_measurement = doubleValue
        }
        
        let weight_pound: Double = Double(iWeight! * 2.20462);
        let factor_1: Double = (weight_pound * 1.082) + 94.42;
        let factor_2: Double = Double(waist_measurement * 4.15);
        let Lean_Body_Mass: Double = factor_1 - factor_2;
        let Body_Fat_Weight: Double = weight_pound - Lean_Body_Mass;
        let Body_Fat_Percentage: Double = (Body_Fat_Weight * 100) / weight_pound;
        
        let rr = Double(round(Body_Fat_Percentage*10/10))

        return rr
    }
    
    
    
    private func femaleCalculation()->Double{
        
        let iWeight = Double("\(userDataModel?.weight ?? "")")

        var wrist_measurement: Double = 0.0
        var waist_measurement: Double = 0.0
        var hip_measurement: Double = 0.0
        var forearm_measurement: Double = 0.0

        if let doubleValue = Double(self.txtWristMesu.text!) {
            wrist_measurement = doubleValue
        }
        if let doubleValue = Double(self.txtWaistMesu.text!) {
            waist_measurement = doubleValue
        }
        if let doubleValue = Double(self.txtHipMesu.text!) {
            hip_measurement = doubleValue
        }
        if let doubleValue = Double(self.txtForearnMesu.text!) {
            forearm_measurement = doubleValue
        }
        
        let weight_pound = iWeight! * 2.20462;
        let factor_1 = (weight_pound * 0.732) + 8.987;
        let factor_2 = wrist_measurement / 3.140;
        let factor_3 = waist_measurement * 0.157;
        let factor_4 = hip_measurement * 0.249;
        let factor_5 = forearm_measurement * 0.434;
        
        let Lean_Body_Mass = factor_1 + factor_2 - factor_3 - factor_4 + factor_5;
        let Body_Fat_Weight = weight_pound - Lean_Body_Mass;
        let Body_Fat_Percentage = (Body_Fat_Weight * 100) / weight_pound;
        
        let rr = Double(round(Body_Fat_Percentage*10/10))
        
        return rr

    }
}
