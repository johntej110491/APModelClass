//
//  RootVC.swift
//  DietApp
//
//  Created by user on 28/06/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

class RootVC: UIViewController {
    @IBOutlet weak var imgBG: UIImageView!
    var isRootNotification = Bool()

    
    
   // version 1.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //---****--Custom Splash Screen--****---//
        if (DeviceType.IS_IPHONE_4_OR_LESS) {
            imgBG.image = UIImage.init(named: Launch_4)
        }else if (DeviceType.IS_IPHONE_5){
            imgBG.image = UIImage.init(named: Launch_5)
        }else if (DeviceType.IS_IPHONE_6){
            imgBG.image = UIImage.init(named: Launch_6)
        }else if (DeviceType.IS_IPHONE_6p){//6P
            imgBG.image = UIImage.init(named: Launch_6P)
        }else if (DeviceType.IS_IPHONE_X){
            imgBG.image = UIImage.init(named: Launch_X)
        } else {//Other
            imgBG.image = UIImage.init(named: Launch_X)
        }
        root()
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func root() {
        
        /*
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let navigationController = UINavigationController(rootViewController: vc)
        appDelegate.window?.rootViewController = navigationController
        appDelegate.window?.makeKeyAndVisible()
        navigationController.setNavigationBarHidden(true, animated: false)
        return
        */
 
        print(UserDefaults_FindData(keyName: UserData))
        
        if let dict = UserDefaults.standard.dictionary(forKey: UserData){
            print(dict)
            userDataModel = UserDataMedel(dictionary: dict as NSDictionary)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            viewController.isRootNotification = isRootNotification
            let navigationController = NavigationController(rootViewController: viewController)
            let mainViewController = MainViewController()
            mainViewController.rootViewController = navigationController
            mainViewController.setup(type: UInt(2))
            appDelegate.window?.rootViewController = mainViewController
            
        }else{
            
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let navigationController = UINavigationController(rootViewController: vc)
            appDelegate.window?.rootViewController = navigationController
            appDelegate.window?.makeKeyAndVisible()
            navigationController.setNavigationBarHidden(true, animated: false)
        }
    }
}
