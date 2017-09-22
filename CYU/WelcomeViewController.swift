//
//  WelcomeViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 04/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //MARK: DO NOT OPEN OR DELETE
        // Creating dummy database 
//        createFirebaseData()
//      removeFirebaseData()
    }
    
    
    //MARK: Create root node
    func createFirebaseData(){
        // And upload data
        // save data of user
        
        let countryName = ["Kenya","Syrian Arab Republic","India","United States","United States","Pakistan","India","Sri Lanka","United Kingdom","United States"]
        let education_level = ["Master","Bachelor","Ph.d"]
        let courseDesp = ["Master_of_Computer_Science","Bachelor of Computer Science","Sprachen"]
        let lang = ["English","German","Hindi"]
        let duration = ["1 Semester","2 Semester","4 Semester"]
        let fee = ["300 euro","700 euro","100 euro"]
        let discipline = ["computer","information technology","engineering"]
        let uniName = ["University of Kabianga","University of Kalamoon","University of Kalyani","University of Kansas","University of Kansas School of Medicine","University of Karachi","University of Kashmir","University of Kelaniya","University of Kent at Canterbury","University of Kentucky"]
        

        var ref: DatabaseReference!
        ref = Database.database().reference().child("filter&search")
        
        
        for i in 0...9{
            
            let randomint = Int(arc4random_uniform(3))
        
            let dict = ["country":countryName[i],
                        "education_level":education_level[randomint],
                        "program_name":courseDesp[randomint],
                        "program_language":lang[randomint],
                        "program_duration":duration[randomint],
                        "tution_fee":fee[randomint],
                        "discipline":discipline[randomint],
                        "uni_name": uniName[i]]
            
            
            let uni_Name = uniName[i].replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
            let course_Desp=courseDesp[randomint].replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
//            let keyName = String("\(uni_Name)+\(course_Desp)")!
            let keyName = uni_Name + course_Desp
            // update Root child name
            ref.child(keyName).setValue(dict)
        }

    }
    
    //MARK: Remove root node
    func removeFirebaseData(){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("filter&search").setValue(nil);
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

