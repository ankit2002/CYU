//
//  LoginViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 08/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {

    
    // MARK: Outlet Variables
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    // MARK: System Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // hide keyboard when tap arround
        self.hideKeyboardWhenTappedArround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextField Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == username){
            if (textField.text?.isEmpty)!{
                alert(message: "Please Enter your Email Address")
                return false;
            }
            else if (!self.checkEmailAddress(str: username.text!)){
                username.becomeFirstResponder()
                alert(message: "OOPs, Seems like your email Address is not Correct")
                return false
            }
            // Error Check next tag failed
            let nextTextField:UITextField = self.view.viewWithTag(textField.tag+1) as! UITextField
            nextTextField.becomeFirstResponder()
            return true
        }
        if(textField == password){
            if (textField.text?.isEmpty)!{
                alert(message: "Please Enter your password")
                return false;
            }
            textField.resignFirstResponder()
            return true
        }
        
        return true
    }
    
    
    
    
    //MARK: Login button Pressed
    @IBAction func loginBtnPressed(_ sender: Any) {

        
        self.openHomeView()
        /* // Original code
        if self.checkValidation(){
            // open Home Menu
            self.openHomeView()
        }
        else{
            // TODO: Business logic to check from DB
            //alert(message: "Username and password are incorrect")
        }
         */
    }
    
    // MARK: Check Validation
    func checkValidation() -> Bool {
        if (username.text?.isEmpty)!{
            username.becomeFirstResponder()
            alert(message: "Please Enter your EMail")
            return false
        }
        
        if (!self.checkEmailAddress(str: username.text!)){
            username.becomeFirstResponder()
            alert(message: "OOPs, Seems like your email Address is not Correct")
            return false
        }
        
        if (password.text?.isEmpty)!{
            password.becomeFirstResponder()
            alert(message: "Please Enter your Password")
            return false
        }
        
        return true
    }

    func checkEmailAddress(str:String) -> Bool {
        let regExForEmail = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}"
        let checkPredicate = NSPredicate (format: "SELF MATCHES %@", regExForEmail)
        return checkPredicate.evaluate(with:str)
    }
    
    
    
    func openHomeView(){
    // create viewController code...
    
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "StudentHomeViewController") as! StudentHomeViewController
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "SlideMenuLeftViewController") as! SlideMenuLeftViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        //        UINavigationBar.appearance().tintColor = UIColor (hex: "689F38")
        
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
