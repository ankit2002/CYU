//
//  SlideMenuViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 06/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn


enum LeftMenu : Int{
    case home = 0
    case search_university
    case show_documents
    case wishlist
    case update_profile
    case offered_universities
    case logout
}

class SlideMenuLeftViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    // declaring Variables
    @IBOutlet weak var tableView: UITableView!
    var mainViewController : UIViewController!
    var searchUniversityViewController : UIViewController!
    var showDocumentViewController : UIViewController!
    var wishlistViewController : UIViewController!
    var updateProfileViewController : UIViewController!
    var showAppliedUniversitiesViewController : UIViewController!
    
    var slideMenuOptions = ["Home","Search University","Show Documents","Wishlist","Update Profile","Applied University","Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchUniversityViewController = storyboard.instantiateViewController(withIdentifier: "SearchUniversityViewController") as! SearchUniversityViewController
        self.searchUniversityViewController = UINavigationController(rootViewController: searchUniversityViewController)
        
        let showDocumentViewController = storyboard.instantiateViewController(withIdentifier: "ShowDocumentViewController") as! ShowDocumentViewController
        self.showDocumentViewController = UINavigationController(rootViewController: showDocumentViewController)
        
        let wishlistViewController = storyboard.instantiateViewController(withIdentifier: "WishlistViewController") as! WishlistViewController
        self.wishlistViewController = UINavigationController(rootViewController: wishlistViewController)
        
        let updateProfileViewController = storyboard.instantiateViewController(withIdentifier: "UpdateProfileViewController") as! UpdateProfileViewController
        self.updateProfileViewController = UINavigationController(rootViewController: updateProfileViewController)
        
        let showAppliedUniversitiesViewController = storyboard.instantiateViewController(withIdentifier: "ShowAppliedUniversitiesViewController") as! ShowAppliedUniversitiesViewController
        self.showAppliedUniversitiesViewController = UINavigationController(rootViewController: showAppliedUniversitiesViewController)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    
    // MARK: TableView Delegate and DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return slideMenuOptions.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leftMenuCell", for :indexPath )
        cell.textLabel?.text = slideMenuOptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let menu = LeftMenu(rawValue: indexPath.row){
                self.changeViewController(menu)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .home:
                self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case .search_university:
                self.slideMenuController()?.changeMainViewController(self.searchUniversityViewController, close: true)
        case .show_documents:
            self.slideMenuController()?.changeMainViewController(self.showDocumentViewController, close: true)
        case .wishlist:
            self.slideMenuController()?.changeMainViewController(self.wishlistViewController, close: true)
        case .update_profile:
            self.slideMenuController()?.changeMainViewController(self.updateProfileViewController, close: true)
        case .offered_universities:
            self.slideMenuController()?.changeMainViewController(self.showAppliedUniversitiesViewController, close: true)
        case .logout:
            self.logoutMethod()
            
        }
    }
    
    
    func logoutMethod(){
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            // signout from google
                GIDSignIn.sharedInstance().signOut()
            
            print("Signout works")
            
            let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "staringNavigationVC") as! UINavigationController
            let appdelegate :AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.window?.rootViewController = welcomeVC
            
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
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
