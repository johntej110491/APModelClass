//
//  Utility.swift
//  DietApp
//
//  Created by user on 28/06/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

import Foundation
import UIKit
import TTGSnackbar
import SDLoader

var latitude:  Double! = 0.0000
var longitude: Double! = 0.0000

let appDelegate = UIApplication.shared.delegate as! AppDelegate
var mainStoryB : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
var iPadMainStoryB : UIStoryboard = UIStoryboard(name: "iPadMain", bundle: nil)


var mainStoryboard = DeviceType.IS_IPAD ? mainStoryB : mainStoryB
var utilityStoryB : UIStoryboard = UIStoryboard(name: "Utility", bundle: nil)

var isPad = UIDevice.current.userInterfaceIdiom == .pad
let reachability = Reachability()!

var USER_DEVICE_ID :String = UIDevice.current.identifierForVendor!.uuidString

enum LanguageSetting: String {
    case en,ar
}

//let CurrentLanguage = UserDefaults_FindData(keyName: APP_LANGUAGE) as! String
//let isEnglishLang: Bool = CurrentLanguage == LanguageSetting.en.rawValue


//MARK:-
let sdLoader = SDLoader()
public func sdLoaderr()  {
    sdLoader.spinner?.lineWidth = 10
    sdLoader.spinner?.spacing = 0.2
    sdLoader.spinner?.sectorColor = #colorLiteral(red: 0.3731715381, green: 0.6672813296, blue: 0.1684150994, alpha: 1)
    sdLoader.spinner?.textColor = #colorLiteral(red: 0.9711773992, green: 0.04454751313, blue: 0.04354131222, alpha: 1)
    sdLoader.spinner?.animationType = AnimationType.anticlockwise
}

var userDataModel: UserDataMedel?

//---------encoded--------
func UserDefaults_SaveData(dictData:Any ,keyName: String) {
   // UserDefaults.standard.removeObject(forKey: keyName)
    
    //let encodedData = NSKeyedArchiver.archivedData(withRootObject: dictData)
    UserDefaults.standard.setValue(dictData, forKey: keyName)
    UserDefaults.standard.synchronize()
}

//---------decoded--------
func UserDefaults_FindData(keyName: String) -> Any {
    if UserDefaults.standard.object(forKey: keyName) != nil {
        
        if  let decoded = UserDefaults.standard.object(forKey: keyName) {
           // let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data)
            print("-\(keyName)--:\(decoded)")
            return decoded as Any
        }
    }
    return "";
}

// MARK:- api_ExtraParameter Methods color, size
func jsonPrettyString(from object: Any) -> String? {
    if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
        let objectString = String(data: objectData, encoding: .utf8)
        return objectString
    }
    return nil
}

//---**----Get Current Device Size----***--
struct ScreenSize{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width;
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height;
    static let SCREEN_MAX_LENGTH  = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT);
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT);
}

struct DeviceType{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6p = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0

    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}


//MARK: Validate Validation
func Country_CodeValidate(value: String) -> Bool {
    let PHONE_REGEX = "[0-9]{2}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: value)
    return result
}

func isValidPass(testStr:String) -> Bool {
    let passRegEx = "(?=.*[0-9])(?=.*[&^%$#@()/])(?=.*[a-zA-Z])([a-zA-Z0-9&^%$#@()/]){6,15}"
    let passTest = NSPredicate(format:"SELF MATCHES %@", passRegEx)
    return passTest.evaluate(with: testStr)
}

//MARK: Email Validation
func isValidEmail(testStr:String) -> Bool {
    print("validate emilId: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let result = emailTest.evaluate(with: testStr)
    return result
}
func isValidUrl(testStr:String) -> Bool {
    print("validate emilId: \(testStr)")
    let emailRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let result = emailTest.evaluate(with: testStr)
    return result
}

//MARK: Phone Validation
func mobileNumberValidate(value: String) -> Bool {
    let PHONE_REGEX = "[0-9]{8,15}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: value)
    return result
}


//MARK Space Detect From String
func trim(str: String) -> String {
    let strFinal = str.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    return strFinal as String
}


//MARK:------Message Alert Open------------
func alertOpen(title1: String, message msg: String) {
    let alert = UIAlertController(title:title1 , message: msg, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    let viewController =  (UIApplication.shared.keyWindow?.rootViewController)! as UIViewController
    viewController.present(alert, animated: true, completion: nil)
}


//MARK: Vibration (left and right)
func lockAnimationForView(view: UIView) {
    let lbl: CALayer = view.layer
    let posLbl: CGPoint = lbl.position
    let y: CGPoint = CGPoint(x: posLbl.x - 10,y: posLbl.y)
    let x: CGPoint = CGPoint(x: posLbl.x + 10,y:  posLbl.y)
    let animation: CABasicAnimation = CABasicAnimation(keyPath: "position")
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    animation.fromValue = NSValue(cgPoint: x)
    animation.toValue = NSValue(cgPoint: y)
    animation.autoreverses = true
    animation.duration = 0.08
    animation.repeatCount = 3
    lbl.add(animation, forKey: nil)
}

//MARK: Phone Calling
//MARK: CALLING
func phoneCall(num: NSString) {
    if num.length > 0 {
        let newString: String = num.replacingOccurrences(of: " ", with: "")
        let phNo: String = newString
        let phoneUrl: NSURL = NSURL(string: "telprompt:\(phNo)")!
        if UIApplication.shared.canOpenURL(phoneUrl as URL) {
            UIApplication.shared.openURL(phoneUrl as URL)
        } else {
            alertOpen(title1: "Error", message: "Your device doesn't support Call")
        }
    } else {
        alertOpen(title1: "Error", message: "Don't have contact number ")
    }
}
func openURLScheme(schemeURL: String) {
    var strURL = String()
    if !schemeURL.contains("http://") && !schemeURL.contains("https://") {
        strURL = "http://" + schemeURL
    }else{
        strURL = schemeURL
    }
    
    if let url = URL(string: strURL) {
        
      /*  if #available(iOS 11, *) {
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                if UIApplication.shared.canOpenURL(url1) {
                    UIApplication.shared.open(url1, options: [:], completionHandler: nil)
                }
            }
        }else */
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: {
                (success) in
                print("Open \(schemeURL): \(success)")
            })
        } else {
            let success = UIApplication.shared.openURL(url)
            print("Open \(schemeURL): \(success)")
        }
    }
}

//-----------Convert Image to Base64----------
func convertImageToBase64(image: UIImage) -> String {
    let imageData:NSData =  (UIImageJPEGRepresentation(image, 0.6) as NSData?)!
    let strBase64 = imageData.base64EncodedString(options: .init(rawValue: 0))
    return strBase64
}
//-----------Convert Base64 to Image----------
func convertBase64ToImage(base64: String) -> UIImage {
    //Create your NSData object
    let data = NSData(base64Encoded: base64, options: NSData.Base64DecodingOptions.init(rawValue: 0))
    //And then just create a new image based on the data object
    let image = UIImage(data: data as! Data)
    return image!
}

func localToUTC(date:String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm a"
    dateFormatter.calendar = NSCalendar.current
    dateFormatter.timeZone = TimeZone.current
    
    let dt = dateFormatter.date(from: date)
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    dateFormatter.dateFormat = "H:mm:ss"
    
    return dateFormatter.string(from: dt!)
}
func UTCToLocal(date:String, format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    let dt = dateFormatter.date(from: date)
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = format
    
    return dateFormatter.string(from: dt!)
}

public func timeAgoSince(dateString: String, format: String) -> String {
    
    let strDate = UTCToLocal(date: dateString, format: format)
    //    print(dateString)
    //    let ary = dateString.components(separatedBy: ".")
    //    let dateString = ary[0]
    //    print(dateString)
    //    yyyy-MM-dd'T'HH:mm:ss
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    //dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")

    //dateFormatter.locale = Locale.init(identifier: "en_GB")
    let date: Date = dateFormatter.date(from: strDate)!
    //2017-06-09T09:33:26.97
    //print(date)
    
    let calendar = Calendar.current
    let now = Date()
    let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    var components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
    components.timeZone = TimeZone.init(abbreviation: "UTC")

    
    print("---\(components.hour):(components.minute)--\(components.day)---")

    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    
    //  let timeString = formatter.string(from: date)
    if let year = components.year, year >= 2 {
        return "\(year) years ago"
        //  return "\(year) years ago, \(timeString)"
    }
        
    else if let year = components.year, year >= 1 {
        return "Last year"
    }
        
    else if let month = components.month, month >= 2 {
        //       return "\(month) months ago, \(timeString)"
        return "\(month) months ago"
    }
        
    else if let month = components.month, month >= 1 {
        //     return "Last month, \(timeString)"
        return "Last month"
    }
        
    else if let week = components.weekOfYear, week >= 2 {
        return "\(week) weeks ago"
        //        return "\(week) weeks ago, \(timeString)"
    }
        
    else if let week = components.weekOfYear, week >= 1 {
        return "Last week"
        //       return "Last week, \(timeString)"
    }
        
    else if let day = components.day, day >= 2 {
        return "\(day) days ago"
        //        return "\(day) days ago, \(timeString)"
    }
        
    else if let day = components.day, day >= 1 {
        //        return "Yesterday, \(timeString)"
        return "Yesterday"
        
    }
        
    else if let hour = components.hour, hour >= 2 {
        //       return "\(hour) hours ago, \(timeString)"
        return "\(hour) hours ago"
    }
        
    else if let hour = components.hour, hour >= 1 {
        //   return "1 hour ago, \(timeString)"//An hour ago
        return "1 hour ago"//An hour ago
    }
        
    else if let minute = components.minute, minute >= 2 {
        // return "\(minute) minutes ago, \(timeString)"
        return "\(minute) minutes ago"
    }
        
    else if let minute = components.minute, minute >= 1 {
        return "1 minute ago"//A minute ago
        //      return "1 minute ago, \(timeString)"//A minute ago
    }
        
    else if let second = components.second, second >= 2 {//3
        return "\(second) seconds ago"
        //        return "\(second) seconds ago, \(timeString)"
    }
        
    else if let second = components.second, second < 1 {//3
        return "0 seconds ago"
        //        return "0 seconds ago, \(timeString)"
    }
    else {
        return "Just now"
    }
}

func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.sizeToFit()
    return label.frame.height
}

//"yyyy-MM-dd'T'HH:mm:ss"
public func changeDateFormat(dateString: String, inFormat: String, outFormat: String) -> String {
    
    let str = dateString.replacingOccurrences(of: "Z", with: "")
    let ary = str.components(separatedBy: ".")
    let dateString = ary[0]
    print(dateString)
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = inFormat
    //dateFormatter.locale = Locale.init(identifier: "en_GB")
    let date = dateFormatter.date(from: dateString)
    
    let outPutFormatter = DateFormatter()
    outPutFormatter.dateFormat = outFormat
    let strOP = outPutFormatter.string(from: date!)
    
    return strOP;
}

func iSSnackbarShow( message: String) {
    let snackbar: TTGSnackbar = TTGSnackbar.init(message: message, duration: .short)
    // Change the content padding inset
    snackbar.contentInset = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    // Change margin
    snackbar.leftMargin = 8
    snackbar.rightMargin = 8
    // Change message text font and color
    snackbar.messageTextColor = UIColor.white
    snackbar.messageTextFont = UIFont.boldSystemFont(ofSize: 18)
    // Change snackbar background color
    snackbar.backgroundColor = UIColor.hexStringToUIColor(hex: "#494762")
    snackbar.messageTextAlign = .center
    
    // Change animation duration
    snackbar.animationDuration = 0.5
    // Animation type
    snackbar.animationType = .slideFromTopBackToTop
    snackbar.show()
}

func tipsTimeAgoSince(dateString: String, format: String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
    //dateFormatter.locale = Locale.init(identifier: "en_GB")
    let date: Date = dateFormatter.date(from: dateString)!
    
    let calendar = Calendar.current
    let now = Date()
    let unitFlags: NSCalendar.Unit = [.day, .weekOfYear, .month, .year]
    let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
    
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    
    //  let timeString = formatter.string(from: date)
    if let year = components.year, year >= 2 {
        return "\(year) years ago"
        //  return "\(year) years ago, \(timeString)"
    }
        
    else if let year = components.year, year >= 1 {
        return "Last year"
    }
        
    else if let month = components.month, month >= 2 {
        //       return "\(month) months ago, \(timeString)"
        return "\(month) months ago"
    }
        
    else if let month = components.month, month >= 1 {
        //     return "Last month, \(timeString)"
        return "Last month"
    }
        
    else if let week = components.weekOfYear, week >= 2 {
        return "\(week) weeks ago"
        //        return "\(week) weeks ago, \(timeString)"
    }
        
    else if let week = components.weekOfYear, week >= 1 {
        return "Last week"
        //       return "Last week, \(timeString)"
    }
        
    else if let day = components.day, day >= 2 {
        return "\(day) days ago"
        //        return "\(day) days ago, \(timeString)"
    }
        
    else if let day = components.day, day >= 1 {
        //        return "Yesterday, \(timeString)"
        return "Yesterday"
        
    }else{
        
        return "Just now"
    }
}
