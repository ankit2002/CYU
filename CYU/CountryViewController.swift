//
//  CountryViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 18/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    var countriesArray : Array<Dictionary<String, String>>!
    var searchActive :Bool = false
    var filterArray : Array<Dictionary<String, String>>!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // load data from plist
        self.loadCountries()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Load data from Plist
    func loadCountries() {
        
        if let fileUrl = Bundle.main.url(forResource: "CountryList", withExtension: "plist"){
            do{
                let data = try Data (contentsOf: fileUrl)
                let dataArray = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [Dictionary<String, String>]
                countriesArray = dataArray
            }catch{
                print("Error on Reading Files",error)
            }
        }
        
        
        print( countriesArray.count)
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
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterArray = countriesArray.filter({ (dictionary: [String:String]) -> Bool in
            for (_, name) in dictionary {
                if (name.range(of: searchText) != nil){
                    return true
                }
            }
            return false
        })
        
        
        if(filterArray .count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        tableView.reloadData()
    }
    
    
    // MARK: - Table View Datasource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryName")!
        
        if searchActive {
                cell.textLabel?.text = filterArray[indexPath.row]["name"]
        }
        else{
                cell.textLabel?.text = countriesArray[indexPath.row]["name"]
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
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
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
