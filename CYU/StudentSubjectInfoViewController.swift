//
//  StudentSubjectInfoViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 11/08/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit

class StudentSubjectInfoViewController: UIViewController {//,UITableViewDataSource,UITableViewDelegate

    //MARK: Variables
    var subjectDetails = SubjectListStruct()
    
    //MARK: IB variables
    @IBOutlet weak var subjectName: UILabel!
    @IBOutlet weak var subjectProf: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        subjectName.text = subjectDetails.subjectName
        subjectProf.text = subjectDetails.subject_workload
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
