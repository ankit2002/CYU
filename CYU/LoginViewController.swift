//
//  LoginViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 08/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Login buttomn Pressed
    @IBAction func loginBtnPressed(_ sender: Any) {
        // open Home Menu
        
        // create viewController code...
        
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "StudentHomeViewController") as! StudentHomeViewController
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "SlideMenuLeftViewController") as! SlideMenuLeftViewController
        
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        UINavigationBar.appearance().tintColor = UIColor.blue
        
        
        UINavigationBar.appearance().tintColor = UIColor (hex: "689F38")
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = SlideMenuController (mainViewController: nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        
        appDelegate.window?.backgroundColor = UIColor.white
        appDelegate.window?.rootViewController = slideMenuController
        appDelegate.window?.makeKeyAndVisible()
        
        
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
