//
//  NotificationViewController.swift
//  APNotificationExtention
//
//  Created by user on 26/07/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
        
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
    }

    
    //MARK: Action
    
    @IBAction func actionYes(){
        dismiss(animated: true, completion: nil)

    }
    @IBAction func actionCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func action(){
        

//        let isDate = UserDefaults_FindData(keyName: RECOMMENDED_WATER_DATE) as! String
//        let isCurrentDate = isStrDate()
//        if isDate == "" {
//            UserDefaults_SaveData(dictData: isCurrentDate, keyName: RECOMMENDED_WATER_DATE)
//        }else{
//
//            if isDate != isCurrentDate {//if don't same day for recommended
//                UserDefaults_SaveData(dictData: isCurrentDate, keyName: RECOMMENDED_WATER_DATE)
//                isUpToSelection = -1
//            }else{
//                let isWaterIntake = UserDefaults_FindData(keyName: RECOMMENDED_WATER_INTAKE) as! String
//                isUpToSelection = NSInteger(isWaterIntake)!
//            }
//        }
    }
    
    
    
    
    
    /*
    //---------encoded--------
    func UserDefaults_SaveData(dictData:Any ,keyName: String) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: dictData)
        UserDefaults.standard.set(encodedData, forKey: keyName)
    }
    
    //---------decoded--------
    func UserDefaults_FindData(keyName: String) -> Any {
        if UserDefaults.standard.object(forKey: keyName) != nil {
            let decoded = UserDefaults.standard.object(forKey: keyName)
            let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data)
            return decodedTeams as Any
            
        }else{
            return "";
        }
    }*/
    
}
