//
//  ProfileViewModel.swift
//  CYU
//
//  Created by Ankit Mishra on 02/10/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import UIKit


enum ProfileViewItemType {
    case pictureAndName
    case about
    case email
    case attributes
    case birthday
    case gender
}

protocol ProfileModelItem {
    var type: ProfileViewItemType { get }
    var sectionTitile : String {get}
    var rowCount : Int {get}
}

class ProfileModel: NSObject{
    
    var items = [ProfileModelItem]()
    
    init(userData : Dictionary<String, Any>) {
        super.init()
        
        let data = userData
        let profile = Profile (data: data)!
        
        if let name = profile.fullName  {
            var profileImage = profile.pictureUrl
            
            if profile.pictureUrl == nil {
                profileImage = "user"
            }

            let profileNameAndPic = ProfileViewModelNameAndPicture (name: name, pictureUrl: profileImage!)
            items.append(profileNameAndPic)
        }
        
        if let about = profile.about {
            let profileAbout = ProfileViewModelAbout (about: about)
            items.append(profileAbout)
        }
        
        if let gender = profile.gender {
            let profilegender = ProfileViewModelGender (gender:gender)
            items.append(profilegender)
        }
        
        if let bday = profile.birthday {
            let profilebday = ProfileViewModelBirthday (birthday:bday)
            items.append(profilebday)
        }
        
        
        if let email = profile.email {
            let emailId = ProfileViewModelEmail (email: email)
            items.append(emailId)
        }
        
        let attributes = profile.attributesdata
        if !attributes.isEmpty{
            let attributeItems = ProfileViewModelAttributeItem (attributes: attributes)
            items.append(attributeItems)
        }
    }

}





extension ProfileModel : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        
        switch item.type {
            
        case .pictureAndName:
            if let cell = tableView.dequeueReusableCell(withIdentifier: NamePictureTableViewCell.identifier, for: indexPath) as? NamePictureTableViewCell{
                cell.item  = item
                return cell
            }
            
            
        case .about:
            if let cell = tableView.dequeueReusableCell(withIdentifier: AboutTableViewCell.identifier, for: indexPath) as? AboutTableViewCell {
                cell.item = item
                return cell
            }
            
        case .email:
            if let cell = tableView.dequeueReusableCell(withIdentifier: EmailTableViewCell.identifier, for: indexPath) as? EmailTableViewCell {
                cell.item = item
                return cell
            }
            
            
        case .attributes:
            if let item = item as? ProfileViewModelAttributeItem, let cell = tableView.dequeueReusableCell(withIdentifier: AttributesTableViewCell.identifier, for: indexPath) as? AttributesTableViewCell {
                cell.item = item.attributes[indexPath.row]
                return cell
            }
            
        case .gender:
            if let cell = tableView.dequeueReusableCell(withIdentifier: GenderTableViewCell.identifier, for: indexPath) as? GenderTableViewCell {
                cell.item = item
                return cell
            }
            
        case .birthday:
            if let cell = tableView.dequeueReusableCell(withIdentifier: BirthdayTableViewCell.identifier, for: indexPath) as? BirthdayTableViewCell {
                cell.item = item
                return cell
            }
            
            
            
            
        }
        return UITableViewCell()
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].sectionTitile
    }
    
    
}



//MARK:- Name And Picture
class ProfileViewModelNameAndPicture: ProfileModelItem {
    
    var type: ProfileViewItemType {
        return .pictureAndName
    }
    
    var sectionTitile: String {
        return "Candidate Info"
    }
    
    var rowCount: Int {
        return 1
    }
    var name : String
    var picUrl : String
    
    init(name:String,pictureUrl:String) {
        self.name = name
        self.picUrl = pictureUrl
    }
}

//MARK:- About
class ProfileViewModelAbout: ProfileModelItem {
    
    var type: ProfileViewItemType {
        return .about
    }
    
    var sectionTitile: String {
        return "About"
    }
    
    var rowCount: Int {
        return 1
    }
    
    var about : String
    
    init(about:String) {
        self.about = about
    }
}

//MARK:- Gender
class ProfileViewModelGender: ProfileModelItem {
    
    var type: ProfileViewItemType {
        return .gender
    }
    
    var sectionTitile: String {
        return "Gender"
    }
    
    var rowCount: Int {
        return 1
    }
    
    var gender : String
    
    init(gender:String) {
        self.gender = gender
    }
}


//MARK:- Birthday
class ProfileViewModelBirthday: ProfileModelItem {
    
    var type: ProfileViewItemType {
        return .birthday
    }
    
    var sectionTitile: String {
        return "Birthday"
    }
    
    var rowCount: Int {
        return 1
    }
    
    var bday : String
    
    init(birthday:String) {
        self.bday = birthday
    }
}


//MARK:- Email
class ProfileViewModelEmail: ProfileModelItem {
    
    var type: ProfileViewItemType {
        return .email
    }
    
    var sectionTitile: String {
        return "Email"
    }
    
    var rowCount: Int {
        return 1
    }
    
    var email : String
    
    init(email:String) {
        self.email = email
    }
}


//MARK:- Attributes
class ProfileViewModelAttributeItem: ProfileModelItem {
    
    var type: ProfileViewItemType {
        return .attributes
    }
    
    var sectionTitile: String {
        return "Details"
    }
    
    var rowCount: Int {
        return attributes.count
    }
    
    var attributes : [Attributes]
    
    init(attributes:[Attributes]) {
        self.attributes = attributes
    }
}
