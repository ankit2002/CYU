//
//  SearchUniversityViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 08/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SearchUniversityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK: Define Variables
    var cellDescriptores : Array<Any>!
//    var listofUniversities = Array<Universities>()
    var listofUniversities = [Universities]()
    var uniNameToPass : String!
    var initialRow = 10
    var loadingData = false
    var keyOfLastElementOfTheSnap : String!
    var valueOfLastElementOfTheSnap : String!
    
    
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
    private func fetchDataFromFirebaseDatabase(){
        
        // to disable interactions
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("universities")
        
//        ref.observeSingleEvent(of: .value, with: { snapshots in
//            
//            if  snapshots.exists() {
//                guard let snap = snapshots.children.allObjects as? [DataSnapshot] else {return}
//                
//                var newUniDict = [Universities]()
//                for s in snap{
//                     let entry = Universities (snapshot: s as DataSnapshot)
//                    newUniDict.append(entry)
//                }
//                
//                self.listofUniversities = newUniDict
//                print(self.listofUniversities.count)
//                // to enable interactions
//                DispatchQueue.main.async {
//                    
//                    self.tableView.reloadData()
//                    UIApplication.shared.endIgnoringInteractionEvents()
//                    self.activityIndicator.stopAnimating()
//                }
//            }
//            else{
//                
//                
//                DispatchQueue.main.async {
//                    UIApplication.shared.endIgnoringInteractionEvents()
//                    self.activityIndicator.stopAnimating()
//                }
//            }
//        })
        
        // SOmething New Bound to Happen
        
        
        if keyOfLastElementOfTheSnap == nil {
            
            ref.queryOrderedByKey().queryLimited(toFirst: 10).observeSingleEvent(of: .value, with: { snapshots in
                
                if snapshots.exists(){
                    
                    guard let snap = snapshots.children.allObjects as? [DataSnapshot] else {return}
                    
                    var newUniDict = [Universities]()
                    for s in snap{
                        let entry = Universities (snapshot: s as DataSnapshot)
                        newUniDict.append(entry)
                    }
                    
                    let lastData = snap.last!
                    self.keyOfLastElementOfTheSnap = lastData.key
                    self.valueOfLastElementOfTheSnap = lastData.childSnapshot(forPath: "basic_info/name").value as! String
                    self.listofUniversities.append(contentsOf: newUniDict)
                    
                    // to enable interactions
                    self.stopSpinnerAndResumeInteraction(check: true)
                }
                else{
                    self.stopSpinnerAndResumeInteraction(check: false)
                }
            }) // end of query
        }
        else{ // to fetch further Data
            ref.queryOrderedByKey().queryStarting(atValue: self.valueOfLastElementOfTheSnap).queryLimited(toFirst: 101).observeSingleEvent(of: .value, with: { snapshots in
                
                if snapshots.exists(){
                    
                    guard let snap = snapshots.children.allObjects as? [DataSnapshot] else {return}
                    
                    var newUniDict = [Universities]()
                    for s in snap{
                        if s.key != self.keyOfLastElementOfTheSnap{
                            let entry = Universities (snapshot: s as DataSnapshot)
                            newUniDict.append(entry)
                        }
                    }
                    
                    let lastData = snap.last!
                    self.keyOfLastElementOfTheSnap = lastData.key
                    self.valueOfLastElementOfTheSnap = lastData.childSnapshot(forPath: "basic_info/name").value as! String
                    self.listofUniversities.append(contentsOf: newUniDict)
                    
                    // enable interaction
                    self.stopSpinnerAndResumeInteraction(check: true)
                }
                else{
                    self.stopSpinnerAndResumeInteraction(check: false)
                }
            }) // end of Query
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
        
        cell.rowName.text = self.listofUniversities[indexPath.row].uni_Name
        cell.rowName.numberOfLines = 0
        cell.wishlistbutton.tag = indexPath.row
        cell.wishlistbutton.addTarget(self, action: #selector(self.wishlistBtnPressed(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // fetching class name and performing segue
        uniNameToPass = self.listofUniversities[indexPath.row].uni_Name
        performSegue(withIdentifier: "StudentUniInfoSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listofUniversities.count
    }
    
    
    // Fetch More Data from Server
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        if !loadingData && indexPath.row == listofUniversities.count-1 {
            loadingData = true
            setupForFurtherDBCall()
        }
        
    }
    
    // Fetch More Data From Database
    func setupForFurtherDBCall() {

        self.loadingData = false
        self.initialRow = self.initialRow + 10
        self.fetchDataFromFirebaseDatabase()
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





