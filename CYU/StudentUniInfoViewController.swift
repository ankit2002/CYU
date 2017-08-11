//
//  StudentUniInfoViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 09/08/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit
import Firebase

class StudentUniInfoViewController: UIViewController {

    //MARK: Variables
    var uniName : String!
    
    //MARK: IB variables
    @IBOutlet weak var uniNameLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: System Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // need to change later on
        setUniName()
        fetchDataFromFirebaseDatabase()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Initialise Method
    func setUniName() {
        uniNameLbl.text = uniName
    }
    

    //MARK: Fetch data from Firebase
    func fetchDataFromFirebaseDatabase(){
        activityIndicator.startAnimating()
        
        var filterString: String!
        
        if !uniName.isEmpty {
            
            let charsToRemove: Set<Character> = Set(".$#[]/".characters)
             filterString = String(uniName.characters.filter{!charsToRemove.contains($0)}).replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
        }
        
        //data/uni_department/8637/South_Arkansas_Community_College
        
        filterString = "South_Arkansas_Community_College"
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("uni_department").child("\(filterString!)")
        ref.observeSingleEvent(of: .value, with: { snapshots in
            
            if  snapshots.exists() {
                guard let snap = snapshots.children.allObjects as? [DataSnapshot] else {return}
                for s in snap{
                    
                    guard let eachEntry = s.value as? Dictionary<String,String> else {
                        print( " no data")
                        return
                    }
                    
                    // Parse Data and save universities
                 print(eachEntry)
                }
                self.activityIndicator.stopAnimating()
                self.updateDataInFirebase(filterStr:filterString)
            }
            else{
                // No data in Firebase
                self.activityIndicator.stopAnimating()
            }
        })
    }
    
    
    func updateDataInFirebase(filterStr:String){
        activityIndicator.startAnimating()
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("uni_department").child("\(filterStr)").child("Faculty_of_Arts_and_Humanities")
        
        let dict1 = ["department_head":"B C BC",
                     "department_name":"Faculty of Law"
        ]
        ref.updateChildValues(dict1)
        
        activityIndicator.stopAnimating()
    }
    
    
    func deleteDataInFirebase(filterStr:String) {
        activityIndicator.startAnimating()
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("uni_department").child("\(filterStr)").child("Faculty_of_Arts_and_Humanities")
        
        ref.removeValue()
        
        activityIndicator.stopAnimating()
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
