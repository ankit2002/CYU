//
//  FilterViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 15/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    let tableData : [String] = ["Country", "Degree Type", "Time Bound", "Field Selection", "Specialized"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Method for Cancel And Done
    @IBAction func dismissVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func donePressed(_ sender: Any) {
        self.dismiss(animated: true) { 
            //send data later on
        }
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
        if indexPath.row == 0 {
            // open country VC
            self.openCountryVC()
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
    
    //MARK: Open country VC
    func openCountryVC(){
        
        if let countryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CountryViewController") as?  CountryViewController {
            if let navigator = navigationController {
                navigator.pushViewController(countryViewController, animated: true)
            }
        }
    }


}
