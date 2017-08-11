//
//  StudentHomeViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 06/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit
import Firebase

class StudentHomeViewController: UIViewController {

    @IBOutlet weak var testlbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserInfo()
        // Do any additional setup after loading the view.
        // save data in DB
    
       // dummyMethodToSaveData()
    
    }
    
    func dummyMethodToSaveData(){
    
    // save data of user
    var ref: DatabaseReference!
    ref = Database.database().reference()
    
    let dict = ["department_head":"A M",
    "department_name":"Faculty of Computer Science"
    ]
    ref.child("uni_department").child("South_Arkansas_Community_College").child("Faculty_of_Arts_and_Humanities").setValue(dict)
        
        
    let dict1 = ["department_head":"S C B",
                "department_name":"Faculty of Law"
    ]
    ref.child("uni_department").child("South_Arkansas_Community_College").child("Faculty_of_Business,_Economics,_and_Social_Sciences").setValue(dict1)
        
        // updating firebse fields
        print("data saved")
    }
    
    func getUserInfo() {
        
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            testlbl.text = user?.email
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBarItem()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}




// MARK: slide Menu Delegate Method
extension StudentHomeViewController : SlideMenuControllerDelegate{
    
    func leftWillOpen() {
//        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
//        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
//        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
//        print("SlideMenuControllerDelegate: leftDidClose")
    }
}
