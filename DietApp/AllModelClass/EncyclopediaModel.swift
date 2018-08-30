//
//  EncyclopediaModel.swift
//  DietApp
//
//  Created by user on 03/07/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

class EncyclopediaModel {

    public var id : String?
    public var title : String?
    public var detail : String?
    public var imgURL : String?
    public var date : String?

    public class func modelsFromDictionaryArray(array:NSArray) -> [EncyclopediaModel] {
        var models:[EncyclopediaModel] = []
        for item in array {
            models.append(EncyclopediaModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        self.id = dictionary["id"] as? String
        self.title = dictionary["name"] as? String
        self.detail = dictionary["details"] as? String
        self.imgURL = dictionary["img"] as? String
        self.date = dictionary["date"] as? String
    }
}
