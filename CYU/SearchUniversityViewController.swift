//
//  SearchUniversityViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 08/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit
import Firebase

// Structure for Universities
struct Universities{
    var uni_Name : String?
    var uni_Country : String?
    var uni_Webpage : String?
    var uni_Country_Code : String?
    var is_uni_verified : Bool?
}

class SearchUniversityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK: Define Variables
    var cellDescriptores : Array<Any>!
    var listofUniversities = Array<Universities>()
    var uniNameToPass : String!
    
    //MARK: Define IB Variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK: System Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        uniNameToPass = nil
        // Do any additional setup after loading the view.
        self.loadDataFromPlist()
        fetchDataFromFirebaseDatabase()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBarItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Fetch data from Firebase
    func fetchDataFromFirebaseDatabase(){
        activityIndicator.startAnimating()
        
        // to disable interactions
        DispatchQueue.main.async {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("universities")
        ref.observeSingleEvent(of: .value, with: { snapshots in
            
            if  snapshots.exists() {
                guard let snap = snapshots.children.allObjects as? [DataSnapshot] else {return}
                for s in snap{
                    
                    guard let eachEntry = s.value as? Dictionary<String,Any> else {
                        print( " no data")
                        return
                    }
                    
                    // Parse Data and save universities
                    self.listofUniversities.append(self.parseDataToStruct(eachEntry: eachEntry))
                }
                
                // to disable interactions
                DispatchQueue.main.async {
                    // enable interactions
                    self.tableView.reloadData()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.activityIndicator.stopAnimating()
                }
            }
            else{
                
                
                DispatchQueue.main.async {
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.activityIndicator.stopAnimating()
                }
            }
        })
    }
    
    //MARK: Parse data as Struct
    func parseDataToStruct(eachEntry : Dictionary<String,Any>) -> Universities {
    
        let data = Universities(uni_Name: eachEntry[keyPath: "basic_info.name"] as? String, uni_Country: eachEntry[keyPath: "basic_info.country"]  as? String, uni_Webpage: eachEntry[keyPath: "basic_info.webpage"]  as? String, uni_Country_Code: eachEntry[keyPath: "basic_info.country_code"]  as? String, is_uni_verified: eachEntry[keyPath: "is_uni_verified"]  as? Bool)
        
        return data
    }
    
    
    
    //MARK: Read Data from plist
    func loadDataFromPlist(){
        
        if let fileUrl = Bundle.main.url(forResource: "FilterList", withExtension: "plist") {
            do{
                let data = try Data (contentsOf: fileUrl)
                let dataArray = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [Any]
                cellDescriptores = dataArray
            }catch{
                print("Error on reading Files ",error);
            }
        }
        self.showData()
    }
    
    
    // Do work with Data
    func showData(){
    }
    
    

    //MARK: Table View Datasource and Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as? SearchTableViewCell else {
            fatalError("Could not dequeue a cell")
        }

//        cell.rowName.text = (self.listofUniversities[indexPath.row]["basic_info"] as? [String:Any])?["name"] as? String
        // will optime it
        // another Solution
//        var dict = self.listofUniversities[indexPath.row]
//        cell.rowName.text = dict[keyPath: "basic_info.name"] as? String
        
        cell.rowName.text = self.listofUniversities[indexPath.row].uni_Name
        cell.rowName.numberOfLines = 0
        cell.wishlistbutton.tag = indexPath.row
        cell.wishlistbutton.addTarget(self, action: #selector(self.wishlistBtnPressed(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        print("ankit")
        
        // fetching class name and performing segue
        uniNameToPass = self.listofUniversities[indexPath.row].uni_Name
        performSegue(withIdentifier: "StudentUniInfoSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listofUniversities.count
    }
    
    
    
    
    
    // Using to pass Uni_Name
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "StudentUniInfoSegue" {
            
            let viewController = segue.destination as! StudentUniInfoViewController
            viewController.uniName = uniNameToPass
        }
    }
 
    
    
    // TODO:
    // MARK: Wishlist button click
    func wishlistBtnPressed(sender:UIButton)  {
        print(sender.tag)
    }

}





