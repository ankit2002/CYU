//
//  AppDelegate.swift
//  CYU
//
//  Created by Ankit Mishra on 04/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    var activityIndicatorView: UIActivityIndicatorView?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // creating window for the screen
//        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        //configuring Firebase
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        
        self.activityIndicatorView  = UIActivityIndicatorView()
        self.activityIndicatorView?.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
        self.activityIndicatorView?.activityIndicatorViewStyle = .gray
        self.activityIndicatorView?.hidesWhenStopped = true
        self.activityIndicatorView?.center = (self.window?.rootViewController?.view.center)!
            
        
        // Check if the user is logged in
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                // open HomeViewController Storyboard
                if (self.activityIndicatorView?.isAnimating)!{
                    self.activityIndicatorView?.stopAnimating()
                }
                
                self.openHomeView()
            }
            else{
                // open WelcomeView Controller Storyboard
                self.openWelcomeVC()
            }
        }
        
        // TODO: Check for the logged in User and fetch Data from Server no need to login Every time
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        // TODO: Check the state of the application
        // user signin work for the speedy Process.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    //MARK: Google Login Work
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }

    // run on iOS 8 and older
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    //MARK: Google Delegate Methods
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        
        self.activityIndicatorView?.startAnimating()
        self.window?.rootViewController?.view.addSubview(self.activityIndicatorView!)
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        // fetching user data from Google
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            // User is signed in
            
            // save data of user
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            let dict = ["Name":user!.displayName,
                        "birthdate":nil,
                        "emailAddress":user!.email,
                        "password":nil,
                        "gender": nil
            ]
            
            ref.child("users").child(user!.uid).setValue(dict)
        }
    }
    
    
    
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    //MARK: Open Home View Controller
    private func openHomeView(){
        
        // TODO: Code Need to be check thorougly and corrected accordingly
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "StudentHomeViewController") as! StudentHomeViewController
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "SlideMenuLeftViewController") as! SlideMenuLeftViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = SlideMenuController (mainViewController: nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }
    
    //MARK: Open Welcome Controller
    private func openWelcomeVC(){
        
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let initialVC = storyboard.instantiateViewController(withIdentifier: "staringNavigationVC")
        self.window?.rootViewController = initialVC
        self.window?.makeKeyAndVisible()
    }

}

