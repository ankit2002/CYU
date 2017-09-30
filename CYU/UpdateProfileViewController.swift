//
//  UpdateProfileViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 08/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit

class UpdateProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    // MARK:- Properties Variables
    var candidateProfile = [Dictionary<String,String>]()
    
    // MARK:- Outlet Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK:- System Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Candidate Profile"
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBarItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK:- TableView Datasource and Delegates
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //  return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
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
