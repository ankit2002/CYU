//
//  FilterViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 15/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


protocol ApplyFilterProtocol {
    func checkAndApplyFilter(check:Bool)
}


class FilterViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {


    var filterSelectedParameter = ["Country":"", "Courses":"", "Semester":"", "Language":"", "Discipline":"", "Education Level":""]
    let filterParameter = ["Country", "Courses", "Semester", "Language", "Discipline", "Education Level"]
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var filterDelegate : ApplyFilterProtocol?
    
    
    //MARK: System Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        fetchFiltersFromDB()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Load Data from DB
    func fetchFiltersFromDB(){
        
        startSpinnerAndResumeInteraction()
        
        let userID = Auth.auth().currentUser!.uid
        var ref : DatabaseReference!
        ref = Database.database().reference().child("users").child(userID).child("filters")
        
        ref.observeSingleEvent(of: .value, with: {snaps in
            
            if snaps.exists(){
                
                guard let snapValue = snaps.children.allObjects as? [DataSnapshot] else {return}
                
                for s in snapValue{
                    
                    let filkey = s.key
                    let filvalue = s.value as! String
                    
                    switch filkey {
                        
                        case "country":
                            self.filterSelectedParameter["Country"] = filvalue
                            
                        case "Courses":
                            self.filterSelectedParameter["Courses"] = filvalue
                            
                        case "program_duration":
                            self.filterSelectedParameter["Semester"] = filvalue
                            
                        case "program_language":
                            self.filterSelectedParameter["Language"] = filvalue
                            
                        case "discipline":
                            self.filterSelectedParameter["Discipline"] = filvalue
                            
                        case "education_level":
                            self.filterSelectedParameter["Education Level"] = filvalue
                            
                        default:
                            print("No data found or filter may be applied on program name,tution or uniName")
                        
                    }
                }
                
                // to enable interactions
                self.stopSpinnerAndResumeInteraction(check: true)
            }else{
                print("no data found")
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
            }
            
            UIApplication.shared.endIgnoringInteractionEvents()
            self.activityIndicator.stopAnimating()
        }
    }
    
    
    
    // MARK: Method for Cancel
    @IBAction func dismissVC(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    // Clear all filters
    @IBAction func clearFilterPressed(_ sender: Any) {
        
        let userID = Auth.auth().currentUser!.uid
        var ref: DatabaseReference!
        ref = Database.database().reference().child("users").child(userID).child("filters")
        ref.setValue(nil)
        
        
        if removeAllValuesOfFilter(){
            self.tableView.reloadData()
        }
        
        // refressing the view
        
        
    }
    
    
    func removeAllValuesOfFilter()->Bool{
        
        for i in filterSelectedParameter{
            filterSelectedParameter.removeValue(forKey: i.key)
        }
        return true
    }
    
    
    // MARK: - TableView DataSource & Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableCell") as! FilterTableViewCell
        
        let keyName = filterParameter[indexPath.row] 
        cell.filterType.text = filterParameter[indexPath.row]
        cell.filterSelectedValue.text = filterSelectedParameter[keyName]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterParameter.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            self.openCountryVC()
        case 1:
            s
        default:
            print("Default is called")
        }
        
        
    }
    
    //MARK: Apply Filter
    @IBAction func applyFilter(_ sender: Any) {
        
        
        self.filterDelegate?.checkAndApplyFilter(check: true)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 */
    
    
    //MARK: Open country VC
    func openCountryVC(){
        
        let countryViewController = self.storyboard?.instantiateViewController(withIdentifier: "CountryViewController") as! CountryViewController
        if let navigator = navigationController{
            navigator.pushViewController(countryViewController, animated: true)
        }
    }


}
