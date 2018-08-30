//
//  FatResultVC.swift
//  DietApp
//
//  Created by user on 09/07/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

class FatResultVC: UIViewController {

    @IBOutlet weak var lblFatRatio: UILabel!
    @IBOutlet weak var imgFat: UIImageView!

    //Get
    var getFatRatio: Double = 0.0
    var getGender:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgFat.image = self.imageSetting()
        lblFatRatio.text = "\(getFatRatio)"
    }

    private func imageSetting()->UIImage{
        var imgFat:UIImage = #imageLiteral(resourceName: "men")
        if getGender == "Male" {
            if (getFatRatio < 20) {//men
                imgFat = #imageLiteral(resourceName: "men")
            } else if (getFatRatio > 20 && getFatRatio < 40) {//men2
                imgFat = #imageLiteral(resourceName: "mens2")
            } else if (getFatRatio > 40 && getFatRatio < 60) {//mens3
                imgFat = #imageLiteral(resourceName: "men3")
            } else if (getFatRatio > 60 && getFatRatio < 80) {//mens4
                imgFat = #imageLiteral(resourceName: "men4")
            } else if (getFatRatio > 80 && getFatRatio < 100) {//mens5
                imgFat = #imageLiteral(resourceName: "men5")
            } else  {//mens5
                imgFat = #imageLiteral(resourceName: "men5")
            }
            
        } else {
            if (getFatRatio < 20) {//Women
                imgFat = #imageLiteral(resourceName: "women")

            } else if (getFatRatio > 20 && getFatRatio < 40) {//Women2
                imgFat = #imageLiteral(resourceName: "women2")

            } else if (getFatRatio > 40 && getFatRatio < 60) {//Women3
                imgFat = #imageLiteral(resourceName: "women3")

            } else if (getFatRatio > 60 && getFatRatio < 80) {//Women4
                imgFat = #imageLiteral(resourceName: "women4")

            } else if (getFatRatio > 80 && getFatRatio < 100) {//Women5
                imgFat = #imageLiteral(resourceName: "women5")

            } else {//Women5
                imgFat = #imageLiteral(resourceName: "women5")

            }
        }
        return imgFat
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action
    @IBAction func action_back(){
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
