//
//  StudentUniInfoViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 09/08/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit
import Firebase


struct Department {
    var departmentName:String?
    var departmentHead :String?
}

class StudentUniInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: Variables
    var uniName : String!
    var listofUniDepartment = Array<Department>()
    var departmentName : String!
    
    //MARK: IB variables
    @IBOutlet weak var uniNameLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    //MARK: System Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
    
    
    func startSpinner(){
        // to disable interactions
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    func getQueryString() -> String? {
        
        if !uniName.isEmpty {
            
            let charsToRemove: Set<Character> = Set(".$#[]/".characters)
            let uni_Name = String(uniName.characters.filter{!charsToRemove.contains($0)}).replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
            return uni_Name
        }else{
            print("Path is not correct")
        }
        
        return nil
    }

    //MARK: Fetch data from Firebase
    private func fetchDataFromFirebaseDatabase(){
        
        let queryString = getQueryString()
        
        startSpinner()
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("universities_department").child("\(queryString!)")
        ref.observeSingleEvent(of: .value, with: { snapshots in
            
            if  snapshots.exists() {
                guard let snap = snapshots.children.allObjects as? [DataSnapshot] else {return}
                for s in snap{
                    
                    guard let eachEntry = s.value as? Dictionary<String,String> else {
                        print( " no data")
                        return
                    }
                    // Parse Data and save Department
                    self.listofUniDepartment.append(self.parseDataToStruct(eachEntry: eachEntry))
                }
                
                self.stopSpinnerAndResumeInteraction(check: true)
            }
            else{
                
                print("No Data Found in Firebase")
                self.stopSpinnerAndResumeInteraction(check: false)
            }
        })
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
    
    
    
    
    
    //MARK: Parse data as Struct
    func parseDataToStruct(eachEntry : Dictionary<String,String>) -> Department {
        
        let data = Department(departmentName: eachEntry[keyPath: "department_name"] as? String, departmentHead: eachEntry[keyPath: "department_head"]  as? String)
        
        return data
    }
    
    
    //MARK: Table View Datasource and Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DepartmentTableViewCell") as? DepartmentTableViewCell else {
            fatalError("Could not dequeue a cell")
        }
        
        
        cell.departmentName.text = self.listofUniDepartment[indexPath.row].departmentName
        cell.departmentHeadName.text = self.listofUniDepartment[indexPath.row].departmentHead
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // SHow options provided by Department
        departmentName = self.listofUniDepartment[indexPath.row].departmentName
        performSegue(withIdentifier: "FacultyProgramInfo", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listofUniDepartment.count
    }
    

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "FacultyProgramInfo" {
            
            let viewController = segue.destination as! StudentProgramViewController
            viewController.uniName = uniName
            viewController.departmentName = departmentName
        }
    }
    

}




/* Testing Methods
 
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
 */
