
//
//  AppDelegate.swift
//  DietApp
//
//  Created by user on 28/06/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import Alamofire
import UserNotificationsUI
@UIApplicationMain






class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var getExpertNumber: String?
    
    let arrayLanguages = Localisator.sharedInstance.getArrayAvailableLanguages()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
    
//        UIFont.familyNames.forEach({ familyName in
//            let fontNames = UIFont.fontNames(forFamilyName: familyName)
//            print(familyName, fontNames)
//        })
        
       // UserDefaults_SaveData(dictData: "\(LanguageSetting.en)", keyName: APP_LANGUAGE)
        languageSetUp()
        
        // For remote Notification
        if (launchOptions?[UIApplicationLaunchOptionsKey.localNotification]) != nil {
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "RootVC") as! RootVC
            vc.isRootNotification = true
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        }
        applicationSetting(application: application)
        
        sdLoaderr()
        return true
    }
    
    private func applicationSetting(application :UIApplication) {
        
        
        IQKeyboardManager.shared.enable = true
        if "\(UserDefaults_FindData(keyName: APNS_TOKEN))" == "" {
            UserDefaults_SaveData(dictData: DEFAULT_TOKEN, keyName: APNS_TOKEN)}
        
        //WaterIntake
        let isWaterIntake = UserDefaults_FindData(keyName: RECOMMENDED_WATER_DATE) as! String
        if isWaterIntake == "" {
            UserDefaults_SaveData(dictData: "-1", keyName: RECOMMENDED_WATER_INTAKE)
        }
 
        //-----Notificatiom premision------
        //registerRemotNotification()
    }
    
    
    var isLang = LanguageSetting.en
    func languageSetUp() {
        
        print(UserDefaults_FindData(keyName: APP_LANGUAGE))
        
        if "\(UserDefaults_FindData(keyName: APP_LANGUAGE))" != "" {
            let str = UserDefaults_FindData(keyName: APP_LANGUAGE) as! String
            isLang = str == "en" ? .en : .ar
        }else{
            UserDefaults_SaveData(dictData: "\(LanguageSetting.en)", keyName: APP_LANGUAGE)
            if SetLanguage(arrayLanguages[0]) {
                print("-------Done: \(arrayLanguages[0])--------")
            }
            return
        }
        
        if isLang.rawValue == LanguageSetting.en.rawValue {
            if SetLanguage(arrayLanguages[0]) {
                print("-------Done: \(arrayLanguages[0])--------")
            }
            
        }else{
            if SetLanguage(arrayLanguages[1]) {
                print("-------Done: \(arrayLanguages[1])--------")
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}


//MARK: UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate{
    
    //-----Notificatiom premision------
 /*   func registerRemotNotification() {
        
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            UIApplication.shared.registerForRemoteNotifications()
        } else {// iOS 7,8,9 support
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
            UIApplication.shared.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
    }
  */
    func getNotificationSettings()  {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings(){ (setttings) in
                
                switch setttings.soundSetting{
                case .enabled:
                    print("Enabled notification sound setting")
                    
                case .disabled:
                    print("Notification setting has been disabled")
                    
                case .notSupported:
                    print("something vital went wrong here")
                }
            }
        }
    }
    
    
    //MARK APNS Delegate methode
    
    // Called when APNs has assigned the device a unique token
  /*  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        UserDefaults_SaveData(dictData: deviceTokenString, keyName: APNS_TOKEN)
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
        UserDefaults_SaveData(dictData: DEFAULT_TOKEN, keyName: APNS_TOKEN)
    }
    
    //MARK APNS Delegate methode
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        handelNotidata(userInfo: userInfo as NSDictionary)
    }
 */
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let dictApsData : NSDictionary = response.notification.request.content.userInfo as NSDictionary
        // print(dictApsData)
        handelNotidata(userInfo: dictApsData)
    }
    
    
    func handelNotidata(userInfo: NSDictionary)  {
        
          print(userInfo)
        let dictInfo = userInfo["aps"] as! NSDictionary
        
        let state: UIApplicationState = UIApplication.shared.applicationState
        
        //  print("----------\(state)---------")
        
        var hostVC = UIApplication.shared.keyWindow?.rootViewController
        while let next = hostVC?.presentedViewController {
            hostVC = next
        }
        
        if userInfo["aps"] != nil {
            
            switch state {
            case .active:
                
                //Find current controller
                if let rootViewController = UIApplication.shared.topViewController() {
//                    if !rootViewController.isKind(of: ChatDetailVc.self) {
//                        iSSnackbarShow(message:  dictInfo["alert"] as! String, animationDuration: 3)
//                    }
                }
                
                break
                
            case .background:
                //...............
                if userInfo["istype"] as! String == "2" {
                    switchToNotification()
                }
                break
                
            case .inactive:
                //...............
                //Find current controller
                if userInfo["istype"] as! String == "2" {
                    switchToNotification()
                }
                break
            }
        }
    }
    
    
    func switchToNotification() {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "RecommendedWaterVC") as! RecommendedWaterVC
        //viewController.isRootNotification = true;
        let navigationController = UINavigationController(rootViewController: viewController)
        appDelegate.window?.rootViewController = navigationController
        appDelegate.window?.makeKeyAndVisible()
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}


//------Find top view controller------
extension UIApplication {
    func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        if let splitViewController = base as? MainViewController {
            return topViewController(base: splitViewController.leftViewController)
        }
        return base
    }
}

//
////MARK - UNNotification Delegate Methods
//extension UIApplication: UNUserNotificationCenterDelegate {
//
//    func didReceive(_ notification: UNNotification) {
//        //self.label?.text = notification.request.content.body
//    }
//
//    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .sound])
//    }
//
//    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//
//        if response.actionIdentifier == "ross" {
//
//        } else {
//            //responseLabel.text = "Try again... or go eat a sandwich."
//        }
//        completionHandler()
//    }
//}
