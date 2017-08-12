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
//  //      createFirebaseData()
//     // removeFirebaseData()
    }
    
    
    //MARK: Create root node
    func createFirebaseData(){
        // And upload data
        // save data of user
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let dict = ["department_head":"A M",
                    "department_name":"Faculty of Computer Science"
        ]
        
        // update Root child name
        ref.child("universities_department_programs_subjects").child("South_Arkansas_Community_College").setValue(dict)
        
    }
    
    //MARK: Remove root node
    func removeFirebaseData(){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("universities_department_Programs").setValue(nil);
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

