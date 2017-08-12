//
//  StudentProgramViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 11/08/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit
import Firebase

struct ProgramStruct {
    var programName : String?
    var programDuration : String?
    var ProgramHead : String?
    var programLanguage : String?
}

class StudentProgramViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    //MARK: Variables
    var listofPrograms = Array<ProgramStruct>()
    var uniName : String!
    var departmentName : String!
    var programNameForNextView : String!
    
    
    //MARK: IB variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchDataFromFirebaseDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Fetch data from Firebase
    func fetchDataFromFirebaseDatabase(){
        
        activityIndicator.startAnimating()
        
        if !uniName.isEmpty && !departmentName.isEmpty {
            
            let charsToRemove: Set<Character> = Set(".$#[]/".characters)
            
            uniName = String(uniName.characters.filter{!charsToRemove.contains($0)}).replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
            
            departmentName = String(departmentName.characters.filter{!charsToRemove.contains($0)}).replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
        }
        else{
            print("Path is not correct")
        }
        
        // universities_department_Programs/University_of_Karachi
        var ref: DatabaseReference!
        ref = Database.database().reference().child("universities_department_programs").child(uniName!).child(departmentName!)
        ref.observeSingleEvent(of: .value, with: { snapshots in
            
            if  snapshots.exists() {
                guard let snap = snapshots.children.allObjects as? [DataSnapshot] else {return}
                for s in snap{
                    
                    guard let eachEntry = s.value as? Dictionary<String,String> else {
                        print( " no data")
                        return
                    }
                    
                    // Parse Data and save Department
                    self.listofPrograms.append(self.parseDataToStruct(eachEntry: eachEntry))
                }
                
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                
            }
            else{
                // No data in Firebase
                print("No Data Found in Firebase")
                self.activityIndicator.stopAnimating()
            }
        })
    }
    
    
    //MARK: Parse data as Struct
    func parseDataToStruct(eachEntry : Dictionary<String,String>) -> ProgramStruct {
        
        let data = ProgramStruct (programName: eachEntry[keyPath: "program_name"] as? String, programDuration: eachEntry[keyPath: "program_duration"] as? String, ProgramHead: eachEntry[keyPath: "program_head"] as? String, programLanguage: eachEntry[keyPath: "program_language"] as? String)
        
        return data
    }
    
    
    //MARK: Table View Datasource and Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudentProgramsTableViewCell") as? StudentProgramsTableViewCell else {
            fatalError("Could not dequeue a cell")
        }
        
        cell.programName.text = self.listofPrograms[indexPath.row].programName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // SHow options provided by Department
        programNameForNextView = self.listofPrograms[indexPath.row].programName
        performSegue(withIdentifier: "StudentSubjectList", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listofPrograms.count
    }
    
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "StudentSubjectList" {
            
            let viewController = segue.destination as! StudentSubjectListViewController
            viewController.uniName = uniName
            viewController.departmentName = departmentName
            viewController.programName = programNameForNextView
        }
        
    }
    

}
