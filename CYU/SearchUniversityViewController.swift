//
//  SearchUniversityViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 08/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit
import Firebase

class SearchUniversityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK: Define Variables
    var cellDescriptores : Array<Any>!
    var listofUniversities = Array<Dictionary <String,String>>()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK: System Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadDataFromPlist()
        fetchDataFromFirebaseDatabase()
    }
    
    
    func fetchDataFromFirebaseDatabase(){
        activityIndicator.startAnimating()
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("universities/0")
        ref.observeSingleEvent(of: .value, with: { snapshots in
            
            if  snapshots.exists() {
                guard let snap = snapshots.children.allObjects as? [DataSnapshot] else {return}
                for s in snap{
                    
                    guard let eachEntry = s.value as? Dictionary<String,Dictionary<String,String>> else {
                        print( " no data")
                        return
                    }
                    self.listofUniversities.append(eachEntry[(eachEntry.first?.key)!]!)
                }
                
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell.rowName.text = self.listofUniversities[indexPath.row]["name"]
        cell.rowName.numberOfLines = 0
        cell.wishlistbutton.tag = indexPath.row
        cell.wishlistbutton.addTarget(self, action: #selector(self.wishlistBtnPressed(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listofUniversities.count
    }
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: 
    func wishlistBtnPressed(sender:UIButton)  {
        print(sender.tag)
    }

}
