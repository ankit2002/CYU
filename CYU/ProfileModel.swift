//
//  ProfileModel.swift
//  CYU
//
//  Created by Ankit Mishra on 02/10/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import Foundation

// MARK:- Attributes Class
class Profile {
    var fullName : String?
    var firstName : String?
    var lastName : String?
    var pictureUrl : String?
    var email : String?
    var about : String?
    var birthday : String?
    var gender : String?
    
    
    var degreeData = [Attributes]()
    var attributesdata = [Attributes]()
    
    init?(data:[String: Any]) {
        
        let nameStr = (data["firstName"] as! String) + " " + (data["lastName"] as! String)
        self.fullName = nameStr
        self.pictureUrl = data["pictureUrl"] as? String
        self.email = data["emailAddress"] as? String
        self.birthday = data["birthdate"] as? String
        self.gender = data["gender"] as? String
        self.about = data["about"] as? String
        
        if let degree = data["DegreeImage"] as?  [String:Any] {
            //self.degreeData = degree.map{ Attributes (data: $0) }
        }
    }
    
}

// MARK:- Attributes Class
class Attributes {
    var key : String?
    var value : String?
    
    init(data:[String: Any]) {
        self.key = "Course Name"
        self.value = data["Course Name"] as? String
    }
    
}
