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

    
    let tableData = ["Country", "Courses", "Years", "Language", "Discipline", "Education Level"]
    
    var filterDelegate : ApplyFilterProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Method for Cancel
    @IBAction func dismissVC(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    // Clear all filters
    @IBAction func clearFilterPressed(_ sender: Any) {
        
        let userID = Auth.auth().currentUser!.uid
        var ref: DatabaseReference!
        ref = Database.database().reference().child("users").child(userID).child("filters")
        ref.setValue(nil)
    }
    
    
    // MARK: - TableView DataSource & Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableCell") as! FilterTableViewCell
        cell.filterType.text = tableData[indexPath.row]
        cell.filterSelectedValue.text = nil
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            self.openCountryVC()
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
