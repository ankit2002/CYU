//
//  CountriesModel.swift
//  CYU
//
//  Created by Ankit Mishra on 19/08/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import Foundation

struct CountriesList {
    var countryCode : String?
    var countryName: String?
    
    init(countryCode:String, countryName: String) {
        self.countryCode = countryCode
        self.countryName = countryName
    }
    
}
