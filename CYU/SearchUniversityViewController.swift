//
//  SearchUniversityViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 08/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SearchUniversityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,ApplyFilterProtocol {
    
    //MARK: Define Variables
    var cellDescriptores : Array<Any>!
    var listofUniversities = [Universities]()
    var uniNameToPass : String!
    
    var loadingData = false
    var keyOfLastElementOfTheSnap : String!
    var valueOfLastElementOfTheSnap : String!
    
    // Filter Work
    var isFilterOn = false
    let filteredUniListGroup = DispatchGroup()
    let filteredUniNameListGroup = DispatchGroup()
    var filteredUniList = [Universities]()
    var uniFromSearchFilter = Array<Dictionary<String,String>>()
    
    
    // Wishlist WOrk
    var wishListArray = [String]()
    var wishListRef: DatabaseReference!
    
    
    
    //MARK: Define IB Variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK: System Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        uniNameToPass = nil
        // Do any additional setup after loading the view.
       // self.loadDataFromPlist()
        fetchInitialDataFromFirebaseDatabase()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBarItem()
        
        // fetch wishlist Data
        fetchWIshlistDataFromFirebase()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        wishListRef.removeAllObservers()
    }
    
    //MARK: to disable interactions
    func startSpinner() {

        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    
    //MARK: Fetch wishlist data from Firebase
    func fetchWIshlistDataFromFirebase(){

        startSpinner()
        self.wishListArray.removeAll()
        
        let userID = Auth.auth().currentUser!.uid
        
        // Data Query
        wishListRef = Database.database().reference().child("UniWishList").child(userID).child("UniList")

        wishListRef.observeSingleEvent(of: .value, with: { snapshots in

            if  snapshots.exists() {
                guard let snap = snapshots.children.allObjects as? [DataSnapshot] else {
                    self.stopSpinnerAndResumeInteraction(check: false)
                    return
                }
                
                for s in snap{
                    self.wishListArray.append(s.value as! String)
                }
                
                self.stopSpinnerAndResumeInteraction(check: true)
            }
            else{
                // No data in Firebase
                print("No Wishlist Data Found in Firebase")
                self.stopSpinnerAndResumeInteraction(check: false)
            }
        })
    }
    
    
    //MARK: Fetch initial data from Firebase
    private func fetchInitialDataFromFirebaseDatabase(){
        
        startSpinner()
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("universities")
        
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
    }
    
    

    //MARK: Table View Datasource and Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as? SearchTableViewCell else {
            fatalError("Could not dequeue a cell")
        }
        
        cell.rowName.text = self.listofUniversities[indexPath.row].uni_Name
        cell.rowName.numberOfLines = 0
        cell.wishlistbutton.tag = indexPath.row
        
        // wishlist selection work
        if wishListArray.contains(cell.rowName.text!){
            cell.wishlistbutton.setImage(UIImage (named: "wishlist_icon_selected"), for: .normal)
        }
        else{
            cell.wishlistbutton.setImage(UIImage (named: "wishlist_icon"), for: .normal)
        }
        
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
        
        if !isFilterOn && !loadingData && indexPath.row == listofUniversities.count-1 {
            loadingData = true
            setupForFurtherDBCall()
        }
        
    }
    
    // Fetch More Data From Database
    func setupForFurtherDBCall() {

        self.loadingData = false
        self.fetchInitialDataFromFirebaseDatabase()
    }
    
    
    
    
    //MARK: Confirm Filter Protocol
    // fetch filtered Data from Server
    func checkAndApplyFilter(check : Bool) {
        
        self.uniFromSearchFilter.removeAll()
        if check {
            isFilterOn = true
            fetchAllFilter()
        }
        else{
         
            // Filters are not applied
            isFilterOn = false
            fetchInitialDataFromFirebaseDatabase()
        }
    }
    
    // Fetch all filter from Server
    func fetchAllFilter() {
        
        startSpinner()
        
        var filterKeyList = [String]()
        var ref : DatabaseReference!
        let userID = Auth.auth().currentUser!.uid
        ref = Database.database().reference().child("users").child(userID).child("filters")
        
        ref.observeSingleEvent(of: .value, with: { snapshot  in

            if snapshot.exists(){
                guard let snap = snapshot.children.allObjects as? [DataSnapshot] else {return}
                
                for s in snap{
                    
                    let filkey = s.key
                    let filvalue = s.value as! String
                    filterKeyList.append(filkey)
                    self.separateFilter(filterKey : filkey , filterValue: filvalue)
                }
                
                
                self.filteredUniNameListGroup.notify(queue: .main) {
                    
                    var countOccurance: [String: Int] = [:]
                    
                    for item in self.uniFromSearchFilter {
                        countOccurance[item["uni_name"]!] = (countOccurance[item["uni_name"]!] ?? 0) + 1
                    }
                    
                    var recordCheck = false
                    
                    // fetch Filtered Uni From DB
                    for (key, value) in countOccurance {
                        
                        if value == filterKeyList.count{
                            recordCheck = true
                            self.fetchUniversitiesFromFilteredData(uniName: key)
                        }
                    }
                    
                    if !recordCheck {
                        self.alert(message: "No Uni found with applied Filter")
                    }

                    
                    self.filteredUniListGroup.notify(queue: .main) {
                        
                        if self.filteredUniList.count > 0{
                            self.listofUniversities.removeAll()
                            self.listofUniversities.append(contentsOf: self.filteredUniList)
                            self.filteredUniList.removeAll()
                            
                            self.stopSpinnerAndResumeInteraction(check: true)
                        }
                        else{
                            self.stopSpinnerAndResumeInteraction(check: false)
                        }
                    }
                }
                
            }
            else{
                print("No Data")
                self.alert(message: "No Uni found with applied Filter")
                self.stopSpinnerAndResumeInteraction(check: false)
            }
        })
    }
    
    
    //MARK: Separate Filter
    func separateFilter(filterKey : String, filterValue: String){
        
        switch filterKey {
        case "country":
            fetchFilterdUniNameFromDB(rootName:"filter&search", keyName:filterKey, valueData: filterValue)
            
        case "program_language":
            fetchFilterdUniNameFromDB(rootName:"filter&search", keyName:filterKey, valueData: filterValue)
            
        case "program_duration":
            fetchFilterdUniNameFromDB(rootName:"filter&search", keyName:filterKey, valueData: filterValue)
            
        case "course":
            fetchFilterdUniNameFromDB(rootName:"filter&search", keyName:filterKey, valueData: filterValue)
            
        case "education_level":
            fetchFilterdUniNameFromDB(rootName:"filter&search", keyName:filterKey, valueData: filterValue)
            
        default:
            print("didn't work")
        }
    }
    

    //MARK: Confirm Filter Protocol
    func fetchFilterdUniNameFromDB(rootName:String, keyName:String, valueData: String) {
        
        filteredUniNameListGroup.enter()
        
        var ref : DatabaseReference!
        ref = Database.database().reference().child(rootName)
        
        ref.queryOrdered(byChild: keyName).queryEqual(toValue: valueData).observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.exists(){
                
                guard let snap = snapshot.children.allObjects as? [DataSnapshot] else {return}
                
                var filArr = Array<Dictionary<String,String>>()
                
                for s in snap{
                    guard let eachEntry = s.value as? Dictionary<String,String> else {
                        print( " no data")
                        return
                    }
                    filArr.append(eachEntry)
                }
                
                self.uniFromSearchFilter.append(contentsOf: filArr)
                
                self.filteredUniNameListGroup.leave()
            }
            else{
                self.filteredUniNameListGroup.leave()
            }
        })
    }
    
    
    
    // this should be called at end only & For every one
    func fetchUniversitiesFromFilteredData(uniName:String){

        filteredUniListGroup.enter()
        
        var ref : DatabaseReference!
        ref = Database.database().reference().child("universities")
        
        ref.queryOrdered(byChild: "basic_info/name").queryEqual(toValue: uniName).observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.exists(){
                
                guard let snap = snapshot.children.allObjects as? [DataSnapshot] else {return}
                
                var newUniDict = [Universities]()
                for s in snap{
                    let entry = Universities (snapshot: s as DataSnapshot)
                    newUniDict.append(entry)
                }
                
                self.filteredUniList.append(contentsOf: newUniDict)
                self.filteredUniListGroup.leave()
            }
            else{
                self.filteredUniListGroup.leave()
            }
        })
    }
    
    

    // Using to pass Uni_Name
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier! {
        
        case "StudentUniInfoSegue":
            let viewController = segue.destination as! StudentUniInfoViewController
            viewController.uniName = uniNameToPass
            
        case "ApplyFilterSegue":
            if let navController = segue.destination as? UINavigationController,
                let viewController = navController.viewControllers.first as? FilterViewController{
                    viewController.filterDelegate = self
            }
            
        default:
            print("Default Data")
        }
    }
 
    
    // MARK: Wishlist button click -- appending data in wishlist
    @objc func wishlistBtnPressed(sender:UIButton)  {
        
        let compareString = listofUniversities[sender.tag].uni_Name!
        let indexpath = IndexPath (row: sender.tag, section: 0)

//        if wishListArray.contains(where: {$0 == compareString}){
        if wishListArray.contains(compareString){
            // Uni is in Array remove it
            if let getIndex = wishListArray.index(of: compareString){
                wishListArray.remove(at: getIndex)
            }
            
            // chnage accessory type
            if let cell = tableView.cellForRow(at: indexpath) as? SearchTableViewCell{
                cell.wishlistbutton.setImage(UIImage (named: "wishlist_icon"), for: .normal)
            }
            
        }else{
            // Uni in not in array add it
            if let cell = tableView.cellForRow(at: indexpath) as? SearchTableViewCell{
                cell.wishlistbutton.setImage(UIImage (named: "wishlist_icon_selected"), for: .normal)
            }
            wishListArray.append(listofUniversities[sender.tag].uni_Name)
        }
        
        // save seleted data in Firebase
        saveSelectedUNIWishListInFirebase(uniWishList: wishListArray)
    }
    
    
    // Mark: Save selected Filter in Firebase under user
    func saveSelectedUNIWishListInFirebase(uniWishList:Array<String>){
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        // get user ID
        let userID = Auth.auth().currentUser!.uid
        
        // To check whether to save or to set nil
//        let childUpdates = ["/users/\(userID)/UniWishList": uniWishList]
        let childUpdates = ["/UniWishList/\(userID)/UniList":uniWishList]
        ref.updateChildValues(childUpdates)
    }
    

    
    // MARK: - Table View Datasource
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    
}
