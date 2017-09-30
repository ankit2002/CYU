//
//  ShowDocumentViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 05/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


struct CourseStructure {
    let courseName : String!
    let courseCompletionDate : String!
    let courseUrl : String!
    let AskForVerification : Bool!
    let isVerified : Bool!
    let uniName : String!
    let isVerifiable : Bool!
}


class ShowDocumentViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    // variables
    var listofCourses = [CourseStructure]()
    var keyArray = [String]()
    var ref: DatabaseReference!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    //MARK: System Method
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBarItem()
        
        // fetch data from Firebase
        fetchDataFromFirebase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // deregister data
        ref.removeAllObservers()
    }
    
    // MARK: Fetch data from Firebase
    func fetchDataFromFirebase(){
        
        self.listofCourses.removeAll()
        self.keyArray.removeAll()
        
        // start the spinnerxx
        self.startSpinnerAndStopInteraction()
        
        let userID = Auth.auth().currentUser!.uid
        
        // Data Query
        
        ref = Database.database().reference().child("users").child(userID).child("DegreeImage")
        
        ref.observe(.value, with: { snapshots in
            
            if  snapshots.exists() {
                guard let snap = snapshots.children.allObjects as? [DataSnapshot] else {
                    self.stopSpinnerAndResumeInteraction(check: false)
                    return
                }
                
                for s in snap{
                    
                    let key = s.key
                    
                    guard let eachEntry = s.value as? Dictionary<String,Any> else {
                        print( " no data")
                        self.stopSpinnerAndResumeInteraction(check: false)
                        return
                    }
                
                    self.keyArray.append(key)
                    // Parse Data and save Department
                    self.listofCourses.append(self.parseDataToStruct(eachEntry: eachEntry))
                }
                
                
                self.stopSpinnerAndResumeInteraction(check: true)
                
            }
            else{
                // No data in Firebase
                print("No Data Found in Firebase")
                
                self.stopSpinnerAndResumeInteraction(check: false)
            }
            
        })
    }
    
    //MARK: Parse data as Struct
    func parseDataToStruct(eachEntry : Dictionary<String,Any>) -> CourseStructure {

        let data = CourseStructure (courseName: eachEntry[keyPath: "Course Name"] as? String, courseCompletionDate: eachEntry[keyPath: "Completion Year"] as? String, courseUrl: eachEntry[keyPath: "degreeImageURL"] as? String, AskForVerification: eachEntry[keyPath: "AskForVerification"] as? Bool, isVerified: eachEntry[keyPath: "isVerified"] as? Bool, uniName: eachEntry[keyPath: "University Name"] as? String, isVerifiable: eachEntry[keyPath: "isVerifiable"] as? Bool)
        return data
    }
    
    
    //MARK: startSpinnerAndStopInteraction
    func startSpinnerAndStopInteraction(){
        DispatchQueue.main.async {
            UIApplication.shared.beginIgnoringInteractionEvents()
            self.activityIndicator.startAnimating()
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
    
    
    
    // MARK: TableView Datasource Method
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.listofCourses.count;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UploadDocCell") as? UploadDocTableViewCell else {
            fatalError("Could not dequeue a cell")
        }
        cell.courseName.text =  self.listofCourses[indexPath.row].courseName
        cell.completionDate.text = self.listofCourses[indexPath.row].courseCompletionDate
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let keyToPass = keyArray[indexPath.row]
        let dataToPass = listofCourses[indexPath.row]
        openAddViewController(data: dataToPass,keyForUpdation:keyToPass)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: Open Add FOr updation of data
    func openAddViewController(data:CourseStructure,keyForUpdation:String){
        
        let addViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddCertificateVC") as! AddCertificateVC
        addViewController.dataForUpdation = data
        addViewController.keyForUpdation = keyForUpdation
        self.navigationController?.pushViewController(addViewController, animated: true)
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
 

}
