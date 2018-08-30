//
//  APIManager.swift
//  DietApp
//
//  Created by user on 28/06/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import Alamofire

//https://mobikul.com/use-map-storing-json-response-model-class/


class APIManager: NSObject {
  class func callAPIBYGET(url:String,OnResultBlock: @escaping (_ dict: NSDictionary,_ status:String) -> Void) {
    
    //"http://expertteam.in/ace_app/webservice/country_list1.php"
    
    
    
    if !reachability.isReachable {
        iSSnackbarShow(message: "No Internet Connection, try later!")
    } else  {
        request(url, method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print("------\(String(describing: response.response?.statusCode))-----")
            if  response.response?.statusCode == nil {
                return;
            }
            
            switch(response.result) {
                
            case .success(_):
                if let data = response.result.value {
                    
                    //                        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])
                    //                        var imgString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
                    //                        imgString = imgString?.replacingOccurrences(of: "null", with: "0") as NSString?
                    //
                    //
                    //                        print(imgString)
                    //
                    //
                    //                        let data: Data? = imgString?.data(using: String.Encoding.utf8.rawValue)
                    //                        let aryValues: NSArray = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                    //                        print(aryValues)
                    
         
                    OnResultBlock( data as! NSDictionary ,"true")
                }
                break
                
            case .failure(_):
                if response.response?.statusCode == 200 {
                    let dic = NSMutableDictionary.init()
                    dic .setValue("Successfully update", forKey: "message")
                    OnResultBlock(dic,"false")
                    
                }else{
                    
                    print(response.result.error!)
                    let dic = NSMutableDictionary.init()
                    dic .setValue("Connection Time Out ", forKey: "message")
                    OnResultBlock(dic,"false")
                }
                break
            }
        }
        }
    }
    
    
    class func callAPIBYPOST(parameter:[String: Any],url:String,  OnResultBlock: @escaping (_ dict: NSDictionary,_ status: Bool) -> Void) {
        
        if !reachability.isReachable {
            iSSnackbarShow(message: "No Internet Connection, try later!")
            
        } else {
            // print(parameter)
            request(url, method: .post, parameters: parameter, encoding: URLEncoding.default).validate(contentType: ["application/json","text/html"]).responseJSON { (response) in
                
                if response.response?.statusCode == nil {
                    let data = ["Message":ERROR_NO_RECORD,"ResponseCode":0] as NSDictionary;
           
                    OnResultBlock(data,false)
                    iSSnackbarShow(message: ERROR_NO_RECORD)
                    return;
                }
                
                
                if (response.response?.statusCode)! != 200 {//No recordFound
                    
                    if let data = response.result.value {
                        //   print("----\(data)")
                        let dataQ = data as! NSDictionary
                        if dataQ.value(forKey: "Message") != nil {
                            OnResultBlock(dataQ ,false)
                            return;
                        }
                    }
                    let data = ["Message":ERROR_NO_RECORD,"ResponseCode":0] as NSDictionary;
                    OnResultBlock(data ,false)
                    iSSnackbarShow(message: ERROR_NO_RECORD)
                    return;
                }
                
                switch(response.result) {
                    
                case .success(_):
                    if let data = response.result.value {
                        OnResultBlock(data as! NSDictionary ,true)
                    }
                    
                    break
                    
                case .failure(_):
                    if response.response?.statusCode == 200 {
                        print(response.value)
                        
                        let dic = NSMutableDictionary.init()
                        dic .setValue("Successfully update", forKey: "Message")
                        OnResultBlock(dic,true)
                        
                    }else{
                        
                        //   print(response.result.error!)
                        let data = ["Message":"Connection Time Out","ResponseCode":0] as NSDictionary;
                        OnResultBlock(data,false)
                    }
                    break
                }
            }
        }
    }
    
    
}
