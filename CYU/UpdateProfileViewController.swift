//
//  UpdateProfileViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 08/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


enum ProfileSection :Int {
    case Profile = 0,Info
}

class UpdateProfileViewController: UIViewController {

    var datamodel: ProfileModel!
    
    // MARK:- Outlet Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK:- System Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Candidate Profile"
        
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableViewAutomaticDimension
        
        tableView?.register(AboutTableViewCell.nib, forCellReuseIdentifier: AboutTableViewCell.identifier)
        tableView?.register(NamePictureTableViewCell.nib, forCellReuseIdentifier: NamePictureTableViewCell.identifier)
        tableView?.register(EmailTableViewCell.nib, forCellReuseIdentifier: EmailTableViewCell.identifier)
        tableView?.register(AttributesTableViewCell.nib, forCellReuseIdentifier: AttributesTableViewCell.identifier)
        tableView?.register(BirthdayTableViewCell.nib, forCellReuseIdentifier: BirthdayTableViewCell.identifier)
        tableView?.register(GenderTableViewCell.nib, forCellReuseIdentifier: GenderTableViewCell.identifier)
        
        tableView.tableFooterView = UIView()
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBarItem()
        self.fetchUserData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Method to Fetch User Data From Firebase
    func fetchUserData() {
        
        let currentUser = Auth.auth().currentUser!
        var ref : DatabaseReference!
        ref = Database.database().reference().child("users").child(currentUser.uid)
        
        var dict =  Dictionary<String,Any>()
        
        
        ref.observeSingleEvent(of: .value, with: {snaps in
            
            if snaps.exists(){
                
                guard let snapValue = snaps.children.allObjects as? [DataSnapshot] else {return}
                
                for s in snapValue{
                    
                    let filkey = s.key
                    let filvalue = s.value
                    
                    dict[filkey] = filvalue
                }
                
                // data collected
                self.datamodel = ProfileModel(userData:dict)
                self.tableView.dataSource = self.datamodel
                self.tableView.reloadData()
            }else{
                print("no data found")
            }
        })
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
