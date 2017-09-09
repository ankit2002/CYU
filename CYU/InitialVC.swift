//
//  InitialVC.swift
//  CYU
//
//  Created by Ankit Mishra on 09/09/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit
import FirebaseAuth

class InitialVC: UIViewController {

    var handle: AuthStateDidChangeListenerHandle?
    
    
    override func viewWillAppear(_ animated: Bool) {
        // Check if the user is logged in
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.openHomeView()
            }
            else{
                // open WelcomeView Controller Storyboard
                self.openWelcomeVC()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool){
        
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Open home View
    func openHomeView() {
        
        // create viewController code...
        
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "StudentHomeViewController") as! StudentHomeViewController
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "SlideMenuLeftViewController") as! SlideMenuLeftViewController
        
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = SlideMenuController (mainViewController: nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        
        appDelegate.window?.backgroundColor = UIColor.white
        appDelegate.window?.rootViewController = slideMenuController
        appDelegate.window?.makeKeyAndVisible()
    }

    
    //MARK: Open Welcome Controller
    private func openWelcomeVC(){
        
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let initialVC = storyboard.instantiateViewController(withIdentifier: "staringNavigationVC")
        appDelegate.window?.rootViewController = initialVC
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
