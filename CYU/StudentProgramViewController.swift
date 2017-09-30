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

    //MARK:- Variables
    var listofPrograms = Array<ProgramStruct>()
    // data to pass
    var uniName : String!
    var departmentName : String!
    var programNameForNextView : String!
    // wishList
    var wishListArray = [Dictionary<String,String>]()
    
    // uni apply
    var uniAppliedArray = [Dictionary<String,Any>]()
    
    
    
    //MARK:- IB variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK:- System Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Branches"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDataFromFirebaseDatabase()
        fetchWIshlistDataFromFirebase()
        fetchUniAppliedDataDataFromFirebase()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    
    //MARK:- String Cleansing
    func getStringForQuery() -> (uniName : String?, deptName : String?) {
    
        if !uniName.isEmpty && !departmentName.isEmpty {
            
            let charsToRemove: Set<Character> = Set(".$#[]/".characters)
            
            let uni_Name = String(uniName.characters.filter{!charsToRemove.contains($0)}).replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
            
            let department_Name = String(departmentName.characters.filter{!charsToRemove.contains($0)}).replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
            
            return (uni_Name, department_Name)
        }else{
            print("Path is not correct")
        }
        
        return (nil, nil)
    }
    
    
    
    //MARK:- Fetch data from Firebase
    private func fetchDataFromFirebaseDatabase(){
        
        self.listofPrograms.removeAll()
        // Get String
        let queryString = getStringForQuery()
        
        // start the spinner
        startSpinner()
        
        // Data Query
        var ref: DatabaseReference!
        ref = Database.database().reference().child("universities_department_programs").child(queryString.uniName!).child(queryString.deptName!)
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
                    self.listofPrograms.append(self.parseDataToStruct(eachEntry: eachEntry))
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
    
    
    //MARK:- Fetch wishlist data from Firebase
    func fetchWIshlistDataFromFirebase(){
        
        self.wishListArray.removeAll()
        startSpinner()

        let userID = Auth.auth().currentUser!.uid
        
        // Data Query
        let wishListRef = Database.database().reference().child("UniWishList").child(userID)
        
        wishListRef.observeSingleEvent(of: .value, with: { snapshots in
            
            if  snapshots.exists() {
                guard let snap = snapshots.children.allObjects as? [DataSnapshot] else {
                    self.stopSpinnerAndResumeInteraction(check: false)
                    return
                }
                
                for s in snap{
                    if s.key == "CourseList"{
                        for innervalue in s.children.allObjects as! [DataSnapshot] {
                            
                            var dict = Dictionary<String,String>()
                            for (k,v) in innervalue.value as! Dictionary<String,String>{
                                dict[k] = v
                            }
                            self.wishListArray.append(dict)
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
    
    //MARK:- Fetch Uni Appled Data from Firebase
    func fetchUniAppliedDataDataFromFirebase(){
        
        uniAppliedArray.removeAll()
        
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
                    
                    self.uniAppliedArray.append(eachEntry)
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
    
    
    
    //MARK: Parse data as Struct
    func parseDataToStruct(eachEntry : Dictionary<String,String>) -> ProgramStruct {
        
        let data = ProgramStruct (programName: eachEntry[keyPath: "program_name"] as? String, programDuration: eachEntry[keyPath: "program_duration"] as? String, ProgramHead: eachEntry[keyPath: "program_head"] as? String, programLanguage: eachEntry[keyPath: "program_language"] as? String)
        
        return data
    }
    
    
    //MARK:- Table View Datasource and Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudentProgramsTableViewCell") as? StudentProgramsTableViewCell else {
            fatalError("Could not dequeue a cell")
        }
        
        cell.programName.text = self.listofPrograms[indexPath.row].programName
        cell.wishListBtn.tag = indexPath.row
        cell.uniApplyBtn.tag = indexPath.row
        
        // wishlist selection work
        let check = wishListArray.first { element in
            return element["Program Name"] == self.listofPrograms[indexPath.row].programName && element["Uni Name"] == uniName && element["Department Name"] == departmentName
        }
        
        if check != nil {
            cell.wishListBtn.setImage(UIImage (named: "wishlist_icon_selected"), for: .normal)
        }
        else{
            cell.wishListBtn.setImage(UIImage (named: "wishlist_icon"), for: .normal)
        }
        
        let applyCheck = uniAppliedArray.first { element in
            return element["ProgramName"] as? String == cell.programName.text && element["UniversityName"] as! String == uniName && element["DepartmentName"] as! String == departmentName
        }
        
        if applyCheck != nil {
            
            if (applyCheck!["AdmissionApproved"] as? Bool)!{
                cell.uniApplyBtn.setImage(UIImage (named: "admission_approved"), for: .normal)
            }
            else{
                cell.uniApplyBtn.setImage(UIImage (named: "applied"), for: .normal)
            }
        }
        else{
            cell.uniApplyBtn.setImage(UIImage (named: "not_applied"), for: .normal)
        }
        
        
        cell.wishListBtn.addTarget(self, action: #selector(self.wishlistBtnPressed(sender:)), for: .touchUpInside)
        cell.uniApplyBtn.addTarget(self, action: #selector(self.uniApplyBtnPressed(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // SHow options provided by Department
        programNameForNextView = self.listofPrograms[indexPath.row].programName
        performSegue(withIdentifier: "StudentSubjectList", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listofPrograms.count
    }
    
    
    // MARK: Wishlist button click -- appending data in wishlist
    @objc func wishlistBtnPressed(sender:UIButton)  {
        
        let compareString = listofPrograms[sender.tag].programName!
        let indexpath = IndexPath (row: sender.tag, section: 0)

        let check = wishListArray.first { element in
            return element["Program Name"] == compareString && element["Uni Name"] == uniName && element["Department Name"] == departmentName
            }
        
        let ind = wishListArray.index { element -> Bool in
            return element["Program Name"] == compareString && element["Uni Name"] == uniName && element["Department Name"] == departmentName
        }

        if check != nil {
            
            wishListArray.remove(at: ind!)
            // chnage accessory type
            if let cell = tableView.cellForRow(at: indexpath) as? StudentProgramsTableViewCell{
                cell.wishListBtn.setImage(UIImage (named: "wishlist_icon"), for: .normal)
            }
            
        }else{
            // Uni in not in array add it
            if let cell = tableView.cellForRow(at: indexpath) as? StudentProgramsTableViewCell{
                cell.wishListBtn.setImage(UIImage (named: "wishlist_icon_selected"), for: .normal)
            }
            
            let dict = ["Program Name":listofPrograms[sender.tag].programName!,"Uni Name":uniName!,"Department Name":departmentName!]
            wishListArray.append(dict)
        }
        
        // save seleted data in Firebase
        saveSelectedBranchWishListInFirebase(courseWishList: wishListArray)
    }
    
    
    // MARK:-  Save selected Filter in Firebase under user
    func saveSelectedBranchWishListInFirebase(courseWishList:Array<Dictionary<String,String>>){
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        // get user ID
        let userID = Auth.auth().currentUser!.uid
        
        // To check whether to save or to set nil
        let childUpdates = ["/UniWishList/\(userID)/CourseList":courseWishList]
        ref.updateChildValues(childUpdates)
    }
    
    //MARK:- Uni Apply Btn Clicked
    fileprivate func applyInUniversity(_ sender: UIButton) {
        /*
        let compareString = listofPrograms[sender.tag].programName!
        let indexpath = IndexPath (row: sender.tag, section: 0)
        
        let check = uniAppliedArray.first { element in
            return element["ProgramName"] as! String == compareString && element["UniversityName"] as! String == uniName && element["DepartmentName"] as! String == departmentName
        }
        
        if check != nil {
            // Dont Change anyThing
            // already applied
            // lock for 10 days
            alert(message: "You already applied for this course!! Please wait for the responce", title: "Info")
            if let cell = tableView.cellForRow(at: indexpath) as? StudentProgramsTableViewCell{
                cell.wishListBtn.setImage(UIImage (named: "applied"), for: .normal)
            }
        }else{
            
            // Data not in array
            // check for verified Doc
            // and then apply
            
            if checkDataVerfiedFromFirebase(){
                
                
                
                // save Data
                saveAppliedUniForStudentInFirebase(courseName:compareString)
            }
            else{
                alert(message: "Please Upload your Data And ask for Verification of It", title: "Info")
            }
        }
        */
        
        if checkDataVerfiedFromFirebase(){
            // save Data
            saveAppliedUniForStudentInFirebase(courseName:listofPrograms[sender.tag].programName!)
        }
        else{
            alert(message: "Please Upload your Data And ask for Verification of It", title: "Info")
        }
        
        
    }
    
    // MARK:- Apply Btn Pressed
    @objc func uniApplyBtnPressed(sender:UIButton) {
        
        let applyCheck = uniAppliedArray.first { element in
            return element["ProgramName"] as? String == listofPrograms[sender.tag].programName && element["UniversityName"] as! String == uniName && element["DepartmentName"] as! String == departmentName
        }
        
        if applyCheck != nil {
            
            if (applyCheck!["AdmissionApproved"] as? Bool)!{
                alert(message: "Your admission is approved")
            }
            else{
                alert(message: "You have already applied to this course!!! Please wait for the responce")
            }
        }
        else{
            showAlert(message: "You can only apply for 5 Universities!! Do you want to Proceed?", sender: sender)
        }
        
    }
    
    
    //MARK:- Method to check if user data is Verified or not
    func checkDataVerfiedFromFirebase()->Bool{
     return true
    }
    
    // Method to save data in Firebase
    func saveAppliedUniForStudentInFirebase(courseName:String){
        
        startSpinner()
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("StudentApplication")
        
        // get user ID
        let userID = Auth.auth().currentUser!.uid
        
        let dict :[String:Any] = ["StudentID":userID,"ProgramName":courseName,"AdmissionApproved":false, "DepartmentName":departmentName,"UniversityName":uniName]
        
        ref.child("/\(userID)").childByAutoId().setValue(dict) { (error, inref) in
            if error == nil{
                self.saveAppliedUniForUniversitiesInFirebase(key:inref.key,data:dict)
            }
            else{
                print(error?.localizedDescription as Any)
                self.stopSpinnerAndResumeInteraction(check: false)
            }
        }
    }
    
    // Method to save data in Firebase
    func saveAppliedUniForUniversitiesInFirebase(key:String,data:Dictionary<String,Any>){
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("StudentApplicationINUniversities").child("\(data["UniversityName"] as! String)")
        
        ref.child("/\(key)").setValue(data) { (error, inref) in
            if error == nil{
                self.alert(message: "Applied Successfully")
                self.uniAppliedArray.append(data)
                self.stopSpinnerAndResumeInteraction(check: true)
            }
            else{
                print(error?.localizedDescription as Any)
                self.stopSpinnerAndResumeInteraction(check: false)
            }
        }
    }

    
    //MARK:- Alert Message
    private func showAlert(message:String, title:String = "", sender:UIButton) {
        let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction (title: "OK", style: .default, handler: { action in
            self.applyInUniversity(sender)
        })
        let cancelAction = UIAlertAction (title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
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
