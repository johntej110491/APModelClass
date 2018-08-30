//
//  DailyTipsModel.swift
//  DietApp
//
//  Created by user on 02/07/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

class DailyTipsModel {
    
    public var id : String?
    public var title : String?
    public var detail : String?
    public var date : String?
    
 
    public class func modelsFromDictionaryArray(array:NSArray) -> [DailyTipsModel] {
        var models:[DailyTipsModel] = []
        for item in array {
            models.append(DailyTipsModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        id = dictionary["id"] as? String
        title = dictionary["heading"] as? String
        detail = dictionary["details"] as? String
        let strDate = tipsTimeAgoSince(dateString: (dictionary["date"] as? String)!, format: "yyyy-MM-dd")
        date = strDate
    }
}

