 
import Foundation


public class UserDataMedel {
	public var user_id : String?
	public var user_name : String?
	public var user_email : String?
	public var user_password : String?
	public var user_country : String?
	public var user_lat : String?
	public var user_long : String?
	public var user_image : String?
	public var user_type : String?
	public var user_created_date : String?
	public var user_device_token : String?
	public var user_status : String?
	public var user_device_type : String?
	public var blood_group : String?
	public var user_gender : String?
	public var height : String?
	public var weight : String?
	public var age : String?
	public var health_status : String?

 
    public class func modelsFromDictionaryArray(array:NSArray) -> [UserDataMedel]
    {
        var models:[UserDataMedel] = []
        for item in array
        {
            models.append(UserDataMedel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

 
	required public init?(dictionary: NSDictionary) {

		user_id = dictionary["user_id"] as? String
		user_name = dictionary["user_name"] as? String
		user_email = dictionary["user_email"] as? String
		user_password = dictionary["user_password"] as? String
		user_country = dictionary["user_country"] as? String
		user_lat = dictionary["user_lat"] as? String
		user_long = dictionary["user_long"] as? String
		user_image = dictionary["user_image"] as? String
		user_type = dictionary["user_type"] as? String
		user_created_date = dictionary["user_created_date"] as? String
		user_device_token = dictionary["user_device_token"] as? String
		user_status = dictionary["user_status"] as? String
		user_device_type = dictionary["user_device_type"] as? String
		blood_group = dictionary["blood_group"] as? String
		user_gender = dictionary["user_gender"] as? String
		height = dictionary["height"] as? String
		weight = dictionary["weight"] as? String
		age = dictionary["age"] as? String
		health_status = dictionary["health_status"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.user_id, forKey: "user_id")
		dictionary.setValue(self.user_name, forKey: "user_name")
		dictionary.setValue(self.user_email, forKey: "user_email")
		dictionary.setValue(self.user_password, forKey: "user_password")
		dictionary.setValue(self.user_country, forKey: "user_country")
		dictionary.setValue(self.user_lat, forKey: "user_lat")
		dictionary.setValue(self.user_long, forKey: "user_long")
		dictionary.setValue(self.user_image, forKey: "user_image")
		dictionary.setValue(self.user_type, forKey: "user_type")
		dictionary.setValue(self.user_created_date, forKey: "user_created_date")
		dictionary.setValue(self.user_device_token, forKey: "user_device_token")
		dictionary.setValue(self.user_status, forKey: "user_status")
		dictionary.setValue(self.user_device_type, forKey: "user_device_type")
		dictionary.setValue(self.blood_group, forKey: "blood_group")
		dictionary.setValue(self.user_gender, forKey: "user_gender")
		dictionary.setValue(self.height, forKey: "height")
		dictionary.setValue(self.weight, forKey: "weight")
		dictionary.setValue(self.age, forKey: "age")
		dictionary.setValue(self.health_status, forKey: "health_status")

		return dictionary
	}

}
