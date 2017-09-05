//
//  CountryViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 18/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class CountryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    var countriesArray = [CountriesList]()
    var searchActive :Bool = false
    var filterArray = [CountriesList]()
    var selectedCountires = [String]()
    
    
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // load data from DB
        self.fetchSelectedCountriesFromDB()
        
        // load data from plist
        self.loadCountries()
        
        // Need to review
        tableView.tableFooterView = tableFooterView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Load Data from DB
    func fetchSelectedCountriesFromDB(){
        
        startSpinnerAndResumeInteraction()
        
        selectedCountires.removeAll()
        
        let userID = Auth.auth().currentUser!.uid
        var ref : DatabaseReference!
        ref = Database.database().reference().child("users").child(userID).child("filters/country")
        
        ref.observeSingleEvent(of: .value, with: {snaps in
        
            if snaps.exists(){
                
                guard let snapValue = snaps.value as? String else {return}

                self.selectedCountires.append(snapValue)
                
                // to enable interactions
                self.stopSpinnerAndResumeInteraction(check: true)
            }else{
                // to enable interactions
                self.stopSpinnerAndResumeInteraction(check: false)
            }
        })
    }
    
    
    // startSpinnerAndResumeInteraction
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
    
    
    // Load data from Plist
    func loadCountries() {
        
        if let fileUrl = Bundle.main.url(forResource: "CountryList", withExtension: "plist"){
            do{
                let data = try Data (contentsOf: fileUrl)
                let dataArray = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [Dictionary<String, String>]
                
                for d in dataArray{
                    countriesArray.append(CountriesList (countryCode: d["code"]!, countryName: d["name"]!))
                }
                
            }catch{
                print("Error on Reading Files",error)
            }
        }
    }
    
    
    // MARK: - Table View Datasource
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // according to swift 4
        filterArray = countriesArray.filter({ (dict:CountriesList) -> Bool in
            return (dict.countryName!.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil)
        })
        
        searchActive = !filterArray.isEmpty
        tableView.reloadData()
    }
    
    
    // MARK: - Table View Datasource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryName")!
        
        var compareString:String
        
        if searchActive && filterArray.count>0 {
            compareString = filterArray[indexPath.row].countryName!
        }
        else{
            compareString = countriesArray[indexPath.row].countryName!
        }
        
        cell.textLabel?.text = compareString
        
        
        // chnage accessory type
        if selectedCountires.contains(where: {$0 == compareString}){
            cell.accessoryType = .checkmark
            
        }else{
            cell.accessoryType = .none
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive {
           return filterArray.count
        }
        
        return countriesArray.count
    }
    
    
    // MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var compareString:String
        
        // add data to selected array
        if searchActive && filterArray.count>0{
            compareString = filterArray[indexPath.row].countryName!
        }
        else{
            compareString = countriesArray[indexPath.row].countryName!
        }
        
        
        if selectedCountires.contains(where: {$0 == compareString}){
            
            // remove element from Array
            if let getIndex = selectedCountires.index(of: compareString){
                selectedCountires.remove(at: getIndex)
            }
            
            // chnage accessory type
            if let cell = tableView.cellForRow(at: indexPath){
                cell.accessoryType = .none
            }
            
        }else{
            
            if selectedCountires.count < 1 {
                // chnage accessory type
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.accessoryType = .checkmark
                }
                
                
                // add data to selected array
                if searchActive && filterArray.count>0{
                    compareString = filterArray[indexPath.row].countryName!
                    selectedCountires.append(filterArray[indexPath.row].countryName!)
                }
                else{
                    selectedCountires.append(countriesArray[indexPath.row].countryName!)
                }
            }
            else{
                alert(message: "You can only select a maximum of 1 countries")
            }
            
        }
        
        
        // Enable and disable done btn
        if selectedCountires.count > 0 {
            doneBtn.isEnabled = true
        }
        else{
            doneBtn.isEnabled = false
        }
    }
    
    // Save Data when done is pressed
    @IBAction func donePressed(_ sender: Any) {
        
        // Saving Data in Firebase
        if selectedCountires.count>0 {
            saveSelectedCountriesInFirebase(checkField: true)
        }
        
        
        if let navigator = self.navigationController{
            navigator.popViewController(animated: true)
        }
    }
    
    
    // Mark: Save selected Filter in Firebase under user
    func saveSelectedCountriesInFirebase(checkField:Bool){
        
        startSpinnerAndResumeInteraction()
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        // get user ID
        let userID = Auth.auth().currentUser!.uid
        
        if checkField {
            
            let childUpdates = ["/users/\(userID)/filters/country": selectedCountires.first!]
            ref.updateChildValues(childUpdates)
        }else{
            
            ref.child("/users/\(userID)/filters/country").setValue(nil)
            self.tableView.reloadData()
        }
        
        
        stopSpinnerAndResumeInteraction(check: false)
    }
    
    
    //MARK: Clear Btn Pressed
    @IBAction func clearBtnPressed(_ sender: Any) {
        
        // remove all data
        selectedCountires.removeAll()
        
        doneBtn.isEnabled = false
        
        // save all data
        self.saveSelectedCountriesInFirebase(checkField:false)
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
