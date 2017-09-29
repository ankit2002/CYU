//
//  ShowAppliedUniversitiesViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 28/09/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ShowAppliedUniversitiesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK:- Properties
    var listOfUni = [Dictionary<String, Any>]()
    
    //MARK:- Outlet Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK:- System Properties
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Universities Applied"
    }

    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBarItem()
        fetchDataOfAppliedUniFromFirebase()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Fetch Data from Server
    func fetchDataOfAppliedUniFromFirebase(){
        
        listOfUni.removeAll()
        
        startSpinner()
        
        let userID = Auth.auth().currentUser!.uid
        
        // Data Query
        let wishListRef = Database.database().reference().child("StudentApplication").child(userID)

        wishListRef.observeSingleEvent(of: .value, with: { snapshots in
            
            if  snapshots.exists() {
                guard let snap = snapshots.children.allObjects as? [DataSnapshot] else {
                    self.stopSpinnerAndResumeInteraction(check: false)
                    return
                }
                
                for s in snap{
                    
                    guard let eachEntry = s.value as? Dictionary<String,Any> else {
                        print( " no data")
                        self.stopSpinnerAndResumeInteraction(check: false)
                        return
                    }
                    
                    self.listOfUni.append(eachEntry)
                }
                
                self.stopSpinnerAndResumeInteraction(check: true)
            }
            else{
                // No data in Firebase
                print("No Application Data Found in Firebase")
                self.stopSpinnerAndResumeInteraction(check: false)
            }
        })
    }
    
    
    //MARK:- Start & Stop Spinner and disable interactions
    func startSpinner(){
        
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
    
    
    // MARK:- TableView DataSource and Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowAppliedCell") as! ShowAppliedUniTableViewCell
        cell.uniName.text = listOfUni[indexPath.row]["UniversityName"] as? String
        cell.courseName.text = listOfUni[indexPath.row]["ProgramName"] as? String
        
        if (listOfUni[indexPath.row]["AdmissionApproved"] as? Bool)!{
            cell.imagePreview.image = UIImage (named: "admission_approved")
        }
        else{
            cell.imagePreview.image = UIImage (named: "applied")
        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfUni.count
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
