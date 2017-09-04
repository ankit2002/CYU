//
//  CommonFilterViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 04/09/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit

class CommonFilterViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var vcTitle = String()
    var dataArray = Array<String>()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: System Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        findFileAsPerFilter(filterName:self.vcTitle)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = vcTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
           // loadDataFromPlist(fileName:"Education Level")
            
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(dataArray[indexPath.row])
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
