//
//  Universities.swift
//  CYU
//
//  Created by Ankit Mishra on 15/08/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import Foundation
import Firebase

// Structure for Universities
struct Universities{
    let uni_Name : String!
    let uni_Country : String!
    let uni_Webpage : String!
    let uni_Country_Code : String!
    let is_uni_verified : Bool!
    
    init(uni_Name:String, uni_Country : String,uni_Webpage : String,uni_Country_Code :String, is_uni_verified: Bool ) {
        self.uni_Name = uni_Name
        self.uni_Country = uni_Country
        self.uni_Webpage = uni_Webpage
        self.uni_Country_Code = uni_Country_Code
        self.is_uni_verified = is_uni_verified
    }
    
    init(snapshot: DataSnapshot) {
        
        // Because Firebase return in Native Data Structure
        let snap = snapshot.value as! NSDictionary
        
        let snapshotValue = snap as! Dictionary<String, Any>
        
        // Name
        if let uniName = snapshotValue[keyPath:"basic_info.name"] as? String {
            uni_Name = uniName
        }
        else{
            uni_Name = ""
        }
        
        // Country
        if let uniCountry = snapshotValue[keyPath: "basic_info.country"] as? String {
            uni_Country = uniCountry
        }
        else{
            uni_Country = ""
        }
        
        // WebPage
        if let uniWebpage = snapshotValue[keyPath:"basic_info.webpage"] as? String{
            uni_Webpage = uniWebpage
        }
        else{
            uni_Webpage = ""
        }
        
        // Country Code
        if let uniCountryCode = snapshotValue[keyPath:"basic_info.country_code"] as? String {
            uni_Country_Code = uniCountryCode
        }
        else{
            uni_Country_Code = ""
        }
        
        // Country Code
        if let isuniverified = snapshotValue[keyPath:"is_uni_verified"] as? Bool {
            is_uni_verified = isuniverified
        }
        else{
            is_uni_verified = false
        }
    }
}
