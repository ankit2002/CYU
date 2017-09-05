//
//  CommonFilterViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 04/09/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CommonFilterViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    // MARK: Properties
    var vcTitle = String()
    var dataArray = Array<String>()
    var selectedFields = [String]()
    
    // MARK: Outlets Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    
    
    
    // MARK: System Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        findFileAsPerFilter(filterName:self.vcTitle)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = vcTitle
        
        // get Field Name and Search IN Firebase for FIlters
        fetchSelectedFilterFromDB(filterName:getFilterKey(title:vcTitle))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: Find key for filter
    func getFilterKey(title:String)->String{
        
        var fieldName = String()
        
        switch title {
            
        case "Courses":
             fieldName = "course"
            
        case "Semester":
            fieldName = "program_duration"
            
        case "Language":
            fieldName = "program_language"
            
        case "Discipline":
            fieldName = "discipline"
            
        case "Education Level":
            fieldName = "education_level"
            
        default:
            print("Invalid filter applied")
        }
        
        return fieldName
        
    }
    
    
    //MARK: Load Data from DB
    func fetchSelectedFilterFromDB(filterName:String){
        
        startSpinnerAndResumeInteraction()
        
        selectedFields.removeAll()
        
        let userID = Auth.auth().currentUser!.uid
        var ref : DatabaseReference!
        ref = Database.database().reference().child("users").child(userID).child("filters").child(filterName)
        
        ref.observeSingleEvent(of: .value, with: {snaps in
            
            if snaps.exists(){
                
                guard let snapValue = snaps.value as? String else {return}
                
                self.selectedFields.append(snapValue)
                
                // to enable interactions
                self.stopSpinnerAndResumeInteraction(check: true)
            }else{
                // to enable interactions
                self.stopSpinnerAndResumeInteraction(check: false)
            }
        })
    }
    
    
    //MARK: FInd file name of applied Filter
    func findFileAsPerFilter(filterName: String) {
        
        switch filterName {
            
        case "Education Level":
            loadDataFromPlist(fileName:"Education Level")
            
        case "Courses":
            loadDataFromPlist(fileName:"Courses List")
            
            
        case "Semester":
            loadDataFromPlist(fileName:"Semester List")
            
        case "Language":
            loadDataFromPlist(fileName:"Language List")
            
        case "Discipline":
            self.alert(message: "No Event attached")
            
        default:
            print("no data in common Filter VC")
        }
        
    }
    

    //MARK: Load Data from Plist
    func loadDataFromPlist(fileName: String)  {
        
        if let fileUrl = Bundle.main.url(forResource: fileName, withExtension: "plist") {
            do{
                let data = try Data (contentsOf: fileUrl)
                let dataarr = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [Any]
                self.dataArray = dataarr as! Array<String>

                // reload data source
                self.tableView.reloadData()
            }catch{
                print("Error on reading Files ",error);
            }
        }
    }
    
    
    // MARK: - TableView DataSource & Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "commonFilterTableCell")!
        cell.textLabel?.text = self.dataArray[indexPath.row]
        
        
        // chnage accessory type
        if selectedFields.contains(where: {$0 == self.dataArray[indexPath.row]}){
            cell.accessoryType = .checkmark
            
        }else{
            cell.accessoryType = .none
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // SOme Work Related to check mark need to varify
        let compareString = dataArray[indexPath.row]
        
        if selectedFields.contains(where: {$0 == compareString}){
            
            // remove element from Array
            if let getIndex = selectedFields.index(of: compareString){
                selectedFields.remove(at: getIndex)
            }
            
            // chnage accessory type
            if let cell = tableView.cellForRow(at: indexPath){
                cell.accessoryType = .none
            }
            
        }else{
            
            if selectedFields.count < 1 {
                // chnage accessory type
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.accessoryType = .checkmark
                }
                
                // add data to selected array
                selectedFields.append(compareString)
            }
            else{
                alert(message: "You can only select a maximum of 1 \(vcTitle)")
            }
            
        }
        
        
        
        
        // WORK END
        
        // Enable and disable done btn
        if selectedFields.count > 0 {
            doneBtn.isEnabled = true
        }
        else{
            doneBtn.isEnabled = false
        }
        
        
    }
    
    
    //MARK: Done Btn Pressed
    @IBAction func doneBtnPressed(_ sender: Any) {
        
        
        // Saving Data in Firebase
        if selectedFields.count>0 {
            saveSelectedFieldsInFirebase(checkField:true)
        }
        
        
        if let navigator = self.navigationController{
            navigator.popViewController(animated: true)
        }
    }
    
    //MARK: Save Data of Filters in Firebase
    func saveSelectedFieldsInFirebase(checkField:Bool){
        startSpinnerAndResumeInteraction()
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        // get user ID
        let userID = Auth.auth().currentUser!.uid

        if checkField{
            let childUpdates = ["/users/\(userID)/filters/\(getFilterKey(title:vcTitle))": selectedFields.first!]
            ref.updateChildValues(childUpdates)
        }else{
            ref.child("/users/\(userID)/filters/\(getFilterKey(title:vcTitle))").setValue(nil)
            self.tableView.reloadData()
        }
        
        stopSpinnerAndResumeInteraction(check: false)
    }
    
    
    //MARK: Clear Btn Pressed
    @IBAction func clearBtnPressed(_ sender: Any) {
        
        // remove all data
        selectedFields.removeAll()
        
        doneBtn.isEnabled = false
        
        // save all data
        self.saveSelectedFieldsInFirebase(checkField:false)
    }
    
    //MARK: startSpinnerAndResumeInteraction
    func startSpinnerAndResumeInteraction(){
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
                self.doneBtn.isEnabled = true
            }
            
            UIApplication.shared.endIgnoringInteractionEvents()
            self.activityIndicator.stopAnimating()
        }
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
