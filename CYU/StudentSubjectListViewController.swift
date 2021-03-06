//
//  StudentSubjectListViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 11/08/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit
import Firebase

struct SubjectListStruct {
    var subjectName : String?
    var subject_info : String?
    var subject_module_code : String?
    var subject_duration : String?
    var subject_teaching_language : String?
    var subject_ects : String?
    var subject_examination : String?
    var subject_workload : String?
    var subject_learning_goal : String?
    var subject_teaching_Method : String?
    var subject_contents : String?
    var subject_literature : String?
    var subject_professor : String?
}

class StudentSubjectListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: Variables
    var listofSubjects = Array<SubjectListStruct>()
    var uniName : String!
    var departmentName : String!
    var programName : String!
    var passSubjectDetails : SubjectListStruct!
    
    //MARK: IB variables
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Subjects"
        // Do any additional setup after loading the view.
        fetchDataFromFirebaseDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Create QueryString For Firebase
    func getQueryString() -> (uni:String?, mergeString:String?) {
        
        if !uniName.isEmpty && !departmentName.isEmpty && !programName.isEmpty {
            
            let charsToRemove: Set<Character> = Set(".$#[]/".characters)
            
            let uni_Name = String(uniName.characters.filter{!charsToRemove.contains($0)}).replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
            
            let department_Name = String(departmentName.characters.filter{!charsToRemove.contains($0)}).replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
            
            let program_Name = String(programName.characters.filter{!charsToRemove.contains($0)}).replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
            
            let mergename = department_Name + "_" + program_Name
//            let mergename = String("\(department_Name)_\(program_Name)")!
            
            return (uni_Name,mergename)
        }
        else{
            print("Path is not correct")
        }
        return (nil,nil)
    }
    
    
    // STart Spinner
    func startSpinner(){
        
        // to disable interactions
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    //MARK: Fetch data from Firebase
    private func fetchDataFromFirebaseDatabase(){
        
        //universities_department_programs_subjects/University_of_Kabianga/Faculty_of_Mathematics_and_Natural_Sciences_Sprachen
        let queryString = getQueryString()
        
        startSpinner()
        
        // query
        var ref: DatabaseReference!
        ref = Database.database().reference().child("universities_department_programs_subjects").child(queryString.uni!).child(queryString.mergeString!)
        ref.observeSingleEvent(of: .value, with: { snapshots in
            
            if  snapshots.exists() {
                guard let snap = snapshots.children.allObjects as? [DataSnapshot] else {return}
                for s in snap{
                    
                    guard let eachEntry = s.value as? Dictionary<String,String> else {
                        print( " no data")
                        self.stopSpinnerAndResumeInteraction(check: false)
                        return
                    }
                    
                    // Parse Data and save Department
                    self.listofSubjects.append(self.parseDataToStruct(eachEntry: eachEntry))
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
    func parseDataToStruct(eachEntry : Dictionary<String,String>) -> SubjectListStruct {
        
        let data = SubjectListStruct (subjectName: eachEntry[keyPath: "subject_name"] as? String, subject_info: eachEntry[keyPath: "subject_info"] as? String, subject_module_code: eachEntry[keyPath: "subject_module_code"] as? String, subject_duration: eachEntry[keyPath: "subject_duration"] as? String, subject_teaching_language: eachEntry[keyPath: "subject_teaching_language"] as? String, subject_ects: eachEntry[keyPath: "subject_ects"] as? String, subject_examination: eachEntry[keyPath: "subject_examination"] as? String, subject_workload: eachEntry[keyPath: "subject_workload"] as? String, subject_learning_goal: eachEntry[keyPath: "subject_learning_goal"] as? String, subject_teaching_Method: eachEntry[keyPath: "subject_teaching_Method"] as? String, subject_contents: eachEntry[keyPath: "subject_contents"] as? String, subject_literature: eachEntry[keyPath: "subject_literature"] as? String, subject_professor: eachEntry[keyPath: "subject_professor"] as? String)
        
        return data
    }
    
    
    
    //MARK: Table View Datasource and Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudentSubjectListTableViewCell") as? StudentSubjectListTableViewCell else {
            fatalError("Could not dequeue a cell")
        }
        
        cell.subjectName.text = self.listofSubjects[indexPath.row].subjectName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        passSubjectDetails = listofSubjects[indexPath.row]
        performSegue(withIdentifier: "StudentSubjectInfo", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listofSubjects.count
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
     
         if segue.identifier == "StudentSubjectInfo" {
            let viewController = segue.destination as! StudentSubjectInfoViewController
            viewController.subjectDetails = passSubjectDetails
            
         }
     
    }
    

}
