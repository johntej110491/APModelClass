//
//  RecommendedWaterVC.swift
//  DietApp
//
//  Created by user on 23/07/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit
import UserNotifications
import DropDown
//let itemWidth: CGFloat = 30
let CellSpacing: CGFloat = 10
var CellCount: NSInteger = 0

class RecommendedWaterVC: UIViewController {

    @IBOutlet weak var collView  : UICollectionView!
    @IBOutlet weak var btnNotificEnable: UIButton!
    @IBOutlet weak var btnNotificList: UIButton!

    
    @IBOutlet weak var lblRecommMsg: UILabel!
    @IBOutlet weak var lblTitleVC: UILabel!

    var isUpToSelection = -1
    var isSelecteRemider = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        isSetting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    private func isSetting() {
        
        CellCount = CaloriesCounterVC().recommendedGlasses()
        lblTitleVC.text = Localization("RECOMMENDED_WATER")
        btnNotificEnable.setTitle(Localization("REMIND_ME"), for: .normal)
        let msg = Localization("REMIND_MSG") + " " + "\(CellCount)" + " " + Localization("REMIND_MSG1")
        lblRecommMsg.text = msg
        
        //Language setup
        let CurrentLanguage = UserDefaults_FindData(keyName: APP_LANGUAGE) as! String
        let isEnglishLang: Bool = CurrentLanguage == LanguageSetting.en.rawValue
        
        let viewMain = self.view.viewWithTag(55555)
        viewMain?.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft
        collView?.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft
        btnNotificEnable?.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft

        btnNotificEnable.contentHorizontalAlignment = isEnglishLang ? .left : .right
        btnNotificList.contentHorizontalAlignment = isEnglishLang ? .left : .right
        
        let b:CGFloat = isEnglishLang ? -10 : 10
        let a:CGFloat =  isEnglishLang ? 10 : -10
        btnNotificEnable.titleEdgeInsets = UIEdgeInsetsMake(0, a, 0, b)
 
        let viewHeader = self.view.viewWithTag(11)
        viewHeader?.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft
        
        
        

        lblRecommMsg.textAlignment = isEnglishLang ? .left : .right
        
        let isDate = UserDefaults_FindData(keyName: RECOMMENDED_WATER_DATE) as! String
        let isCurrentDate = isStrDate()

        if isDate == "" {
            UserDefaults_SaveData(dictData: isCurrentDate, keyName: RECOMMENDED_WATER_DATE)
        }else{
            
            if isDate != isCurrentDate {//if don't same day for recommended
                UserDefaults_SaveData(dictData: isCurrentDate, keyName: RECOMMENDED_WATER_DATE)
                UserDefaults_SaveData(dictData: "0", keyName: RECOMMENDED_WATER_INTAKE)
                removeAllNotification()
                isUpToSelection = -1
            }else{
                let isWaterIntake = UserDefaults_FindData(keyName: RECOMMENDED_WATER_INTAKE) as! String
                isUpToSelection = NSInteger(isWaterIntake)!
                if CellCount == isUpToSelection {
                    removeAllNotification()
                }
            }
        }
        
        
        //Notification setting
        let isStatus = UserDefaults_FindData(keyName: NOTIFICATION_SWITCH) as! String
        if isStatus == "" {
            UserDefaults_SaveData(dictData: OFF, keyName: NOTIFICATION_SWITCH)
        }else{
            let isStatus = UserDefaults_FindData(keyName: NOTIFICATION_SWITCH) as! String
            let image = isStatus == ON ? #imageLiteral(resourceName: "checked") : #imageLiteral(resourceName: "unchecked")
            btnNotificEnable.setImage(image, for: .normal)
            btnNotificList.isHidden = isStatus == ON ? false : true

            if isStatus == ON {//If change date with ON notification
                if isDate != isCurrentDate {
                    action_reminder((Any).self)
                }
            }
        }
        
        collView.reloadData()
    }
    
    private func isStrDate()->String{
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let strDate = "\(day)/\(month)/\(year)"
        return strDate
    }
    
    //MARK: Action
    @IBAction func action_back(){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_reminder_list(_ sender: Any) {
       // remindListDropDown.show()
        
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ReminderPopUpVC") as! ReminderPopUpVC
        vc.delegate = self
        vc.isSelecteRemider = isSelecteRemider
        present(vc, animated: true, completion: nil)
    }
    @IBAction func action_reminder(_ sender: Any) {
        // Request Notification Settings
        let isStatus = UserDefaults_FindData(keyName: NOTIFICATION_SWITCH) as! String
        
        if isStatus == ON {//if ON then always is OFF
            UserDefaults_SaveData(dictData: OFF, keyName: NOTIFICATION_SWITCH)
            removeAllNotification()
            btnNotificEnable.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            btnNotificList.isHidden = true
                  print("--------OooNo--------");
        }else{//if oFF then always is ON
                  print("--------Good--------");
            isSelecteRemider = 1
            addNotication(index: isSelecteRemider)
            btnNotificList.isHidden = false
        }
    }
    
    // MARK: - Private Methods
    private func addNotication(index: NSInteger){
        self.btnNotificList.setTitle(ARY_REMINDER[index], for: .normal)
        removeAllNotification()

        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    // Schedule Local Notification
                    self.scheduleLocalNotification(index: index)
                })
                break
            case .authorized:
                // Schedule Local Notification
                self.scheduleLocalNotification(index: index)
                break
            case .denied:
                print("Application Not Allowed to Display Notifications")
            }
        }
    }
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            completionHandler(success)
        }
    }
    
    private func scheduleLocalNotification(index: NSInteger) {
        
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "DietApp"
        notificationContent.subtitle = "Recommended water"
        notificationContent.body = "Well, you should be take a water."
        notificationContent.categoryIdentifier = "debitOverdraftNotification"

        // Add Trigger
        let fireTime = index == 0 ? 60 : Double(index * 60 * 60)
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(fireTime), repeats: true)

        // Create Notification Request
        let uuidString = UUID().uuidString
        let notificationRequest = UNNotificationRequest(identifier: uuidString, content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }else{
                print("--------Done--------");
                DispatchQueue.main.async {
                    self.btnNotificEnable.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
                    UserDefaults_SaveData(dictData: ON, keyName: NOTIFICATION_SWITCH)
                }
            }
        }
    }
    
    func removeAllNotification() {
        print("--------OooNo--------");
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}


//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension RecommendedWaterVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(CellCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! RecommendedWaterCell
        cell.imgIcon.image = indexPath.row <= isUpToSelection ? #imageLiteral(resourceName: "us_cup_active") : #imageLiteral(resourceName: "us_cup")

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("-------\(isUpToSelection)-------")
        if indexPath.row < isUpToSelection {//Not any intake the water glass
            return
        }
        
        if indexPath.row == 0 {
            isUpToSelection = isUpToSelection == 0 ? -1 : 0
        }else{
            isUpToSelection = indexPath.row
        }
        
        UserDefaults_SaveData(dictData: "\(isUpToSelection)", keyName: RECOMMENDED_WATER_INTAKE)
        collView.reloadData()
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension RecommendedWaterVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //let iWidth = ScreenSize.SCREEN_WIDTH - 52
        //let estimateWidth =  Int(iWidth / itemWidth)
        let iWidthCell =  collectionView.frame.width / 3
        
        let iSize = CGSize(width: iWidthCell, height: iWidthCell)
        return iSize
    }
    
   /* func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth = iWidthCell * CellCount
        let totalSpacingWidth = CellSpacing * (CellCount - 1)
        
        let leftInset = (collectionView.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
    }*/
}


//MARK: ReminderListDelegate
extension RecommendedWaterVC: ReminderItemDelegate {
    func didSelectIReminderIte(item: String, index: NSInteger) {
        isSelecteRemider = index
        self.addNotication(index: index)
    }
}
