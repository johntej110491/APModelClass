//
//  AskQuestionModel.swift
//  DietApp
//
//  Created by user on 10/07/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

class AskQuestionModel {
    
    public var id : String?
    public var user_id : String?
    public var msg : String?
    public var quiz_id : String?
    public var month : String?
    public var date : String?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [AskQuestionModel] {
        var models:[AskQuestionModel] = []
        for item in array {
            models.append(AskQuestionModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        self.id = dictionary["ID"] as? String
        self.user_id = dictionary["user_id"] as? String
        self.msg = dictionary["msg"] as? String
        self.quiz_id = dictionary["quiz_id"] as? String
        self.month = dictionary["month"] as? String
        let strDate = timeAgoSince(dateString: (dictionary["date"] as? String)!, format: "yyyy-MM-dd HH:mm:ss")
        self.date = strDate
    }
}
