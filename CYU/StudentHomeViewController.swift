//
//  StudentHomeViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 06/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit
import Firebase

class StudentHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBarItem()
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




// MARK: slide Menu Delegate Method
extension StudentHomeViewController : SlideMenuControllerDelegate{
    
    func leftWillOpen() {
//        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
//        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
//        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
//        print("SlideMenuControllerDelegate: leftDidClose")
    }
}
