//
//  WishlistViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 08/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class WishlistViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: Local Properties
    var wishListCourseArray = [Dictionary<String,String>]()
    var wishListUniArray = [String]()
    var wishListSection = [String]()
    var uniNameToPass : String!
    var programName : String!
    var departmentName : String!
    var wishListRef: DatabaseReference!
    
    //MARK: IB Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK: System Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "WishList"
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBarItem()
        
        // fetch data
        fetchWIshlistDataFromFirebase()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        wishListRef.removeAllObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: Fetch wishlist data from Firebase
    func fetchWIshlistDataFromFirebase(){
        
        startSpinner()
        self.wishListSection.removeAll()
        self.wishListUniArray.removeAll()
        self.wishListCourseArray.removeAll()
        
        let userID = Auth.auth().currentUser!.uid
        
        // Data Query
        wishListRef = Database.database().reference().child("UniWishList").child(userID)
        
        wishListRef.observeSingleEvent(of: .value, with: { snapshots in
            
            if  snapshots.exists() {
                guard let snap = snapshots.children.allObjects as? [DataSnapshot] else {
                    self.stopSpinnerAndResumeInteraction(check: false)
                    return
                }
                
                for s in snap{
                    self.wishListSection.append(s.key)
                    
                if s.key == "UniList"{
                    for innervalue in s.children.allObjects as! [DataSnapshot] {
                            self.wishListUniArray.append(innervalue.value as! String )
                        }
                    }
                    else if s.key == "CourseList"{
                        for innervalue in s.children.allObjects as! [DataSnapshot] {
                            
                            var dict = Dictionary<String,String>()
                            for (k,v) in innervalue.value as! Dictionary<String,String>{
                                dict[k] = v
                            }
                            
                            self.wishListCourseArray.append(dict)
                        }
                    }
                }
                
                self.stopSpinnerAndResumeInteraction(check: true)
            }
            else{
                // No data in Firebase
                print("No Wishlist Data Found in Firebase")
                self.stopSpinnerAndResumeInteraction(check: false)
            }
        })
    }
    
    
    //MARK: to disable interactions
    func startSpinner() {
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    
    // stopSpinnerAndResumeInteraction
    func stopSpinnerAndResumeInteraction(check:Bool){
        DispatchQueue.main.async {
            if check{
                self.tableView.reloadData()
            }
            
            UIApplication.shared.endIgnoringInteractionEvents()
            self.activityIndicator.stopAnimating()
        }
    }
    
    
    //MARK: Table View Delegate & DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishlistIdentifier") as! WishListTableViewCell
        switch indexPath.section {
        case 0:
            cell.uniName.text = self.wishListUniArray[indexPath.row]
        case 1:
            cell.uniName.text = self.wishListCourseArray[indexPath.row]["Program Name"]
        default:
            cell.uniName.text = "something"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return self.wishListUniArray.count
        case 1:
            return self.wishListCourseArray.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.wishListSection.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            uniNameToPass = self.wishListUniArray[indexPath.row]
            performSegue(withIdentifier: "WishListUniDescription", sender: self)
        case 1:
            uniNameToPass = self.wishListCourseArray[indexPath.row]["Uni Name"]
            programName = self.wishListCourseArray[indexPath.row]["Program Name"]
            departmentName = self.wishListCourseArray[indexPath.row]["Department Name"]
            performSegue(withIdentifier: "WishListCourseDescription", sender: self)
        default:
            print("nothing")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Universities"
        case 1:
            return "Branches"
        default:
            return "null"
        }
    }
    
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier! {
            
        case "WishListUniDescription":
            let viewController = segue.destination as! StudentUniInfoViewController
            viewController.uniName = uniNameToPass
            
        case "WishListCourseDescription":
            let viewController = segue.destination as! StudentSubjectListViewController
            viewController.uniName = uniNameToPass
            viewController.departmentName = departmentName
            viewController.programName = programName
            
        default:
            print("Default Data")
        }
        
        
        
    }
 

}
