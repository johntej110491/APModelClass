//
//  CaloriesModel.swift
//  DietApp
//
//  Created by user on 09/07/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

class CaloriesModel {

    public var id : String?
    public var title : String?
    public var protein : String?
    public var carbohydrates : String?
    public var fats : String?
    public var fiber : String?
    public var quantity : String?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [CaloriesModel] {
        var models:[CaloriesModel] = []
        for item in array {
            models.append(CaloriesModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        self.id = dictionary["ID"] as? String
        self.title = dictionary["Food"] as? String
        self.protein = dictionary["Protin"] as? String
        self.carbohydrates = dictionary["Carbohydrates"] as? String
        self.fats = dictionary["Fats"] as? String
        self.fiber = dictionary["Fiber"] as? String
        self.quantity = dictionary["Quantity"] as? String
    }
    
}
