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
    var selectedCountires = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableFooterView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // load data from plist
        filterArray = []
        self.loadCountries()
        tableView.tableFooterView = tableFooterView
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
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // old ways
//        filterArray = countriesArray.filter({ (dictionary: [String:String]) -> Bool in
//            for  (_,name) in dictionary {
//                if (name.range(of: searchText) != nil){
//                    return true
//                }
//            }
//            return false
//        })
        
        
        
        // according to swift 4 
        // wasted 4 hours for this shit but learned some thing new
        filterArray = countriesArray.filter({ (dict:[String:String]) -> Bool in
            let data = dict.values.filter({ (name) -> Bool in
               return (name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil)
            })
            return data.count>0
        })
        
        searchActive = !filterArray.isEmpty
        tableView.reloadData()
    }
    
    
    // MARK: - Table View Datasource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryName")!
        
        var compareString:String
        
        if searchActive && filterArray.count>0 {
                compareString = filterArray[indexPath.row]["name"]!
        }
        else{
                compareString = countriesArray[indexPath.row]["name"]!
        }
        
        cell.textLabel?.text = compareString
        
        
        if selectedCountires.contains(where: {$0 == compareString}){
            // chnage accessory type
            cell.accessoryType = .checkmark
            
        }else{
            // chnage accessory type
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
            compareString = filterArray[indexPath.row]["name"]!
        }
        else{
            compareString = countriesArray[indexPath.row]["name"]!
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
            
            // chnage accessory type
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .checkmark
            }
            
            
            // add data to selected array
            if searchActive && filterArray.count>0{
                selectedCountires.append(filterArray[indexPath.row]["name"]!)
            }
            else{
                selectedCountires.append(countriesArray[indexPath.row]["name"]!)
            }
        }
        
        
        print(selectedCountires)
        
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
