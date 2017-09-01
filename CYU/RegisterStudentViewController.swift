//
//  RegisterStudentViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 09/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit
import Firebase

class RegisterStudentViewController: UIViewController,UITextFieldDelegate {

    // MARK: Defining Variables
    let datePicker :UIDatePicker = UIDatePicker()
    var currentTextField : UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Defining Outlet Variables
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var birthdate: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var re_password: UITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var scrollview: UIScrollView!
    
    
    
    
    // MARK: - System Methods
    override func viewWillAppear(_ animated: Bool) {
        setupViewResizerOnKeyboardShown();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create datePicker
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
        birthdate.inputView = datePicker
        
        // hide keyboard when tap arround
        self.hideKeyboardWhenTappedArround()
    }
    
    
    func setupViewResizerOnKeyboardShown() {
            //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    // removing Notification Centre when call release resources
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - UItextFiled Delegates and Datasource
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // when start typing on text field
        currentTextField = textField;
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentTextField = nil;
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == firstName{
            if (textField.text?.isEmpty)!{
                alert(message: "Please Enter your First Name")
                return false;
            }
            let nextTextField:UITextField = self.view.viewWithTag(textField.tag+1) as! UITextField
            nextTextField.becomeFirstResponder()
            return true
        }
        else if textField == lastName{
            if (textField.text?.isEmpty)!{
                alert(message: "Please Enter your Last Name")
                return false;
            }
            let nextTextField:UITextField = self.view.viewWithTag(textField.tag+1) as! UITextField
            nextTextField.becomeFirstResponder()
            return true
        }
        else if textField == birthdate{
            if (textField.text?.isEmpty)!{
                alert(message: "Please Enter your birthdate")
                return false;
            }
            let nextTextField:UITextField = self.view.viewWithTag(textField.tag+1) as! UITextField
            nextTextField.becomeFirstResponder()
            return true
        }
        else if textField == emailAddress{
            if (textField.text?.isEmpty)!{
                alert(message: "Please Enter your Email Address")
                return false;
            }
            let nextTextField:UITextField = self.view.viewWithTag(textField.tag+1) as! UITextField
            nextTextField.becomeFirstResponder()
            return true
        }
        else if textField == password{
            if (textField.text?.isEmpty)!{
                alert(message: "Please Enter your Password")
                return false;
            }
            let nextTextField:UITextField = self.view.viewWithTag(textField.tag+1) as! UITextField
            nextTextField.becomeFirstResponder()
            return true
        }
        else if textField == re_password{
            if (textField.text?.isEmpty)!{
                alert(message: "Please Enter your Password Again")
                return false;
            }
            textField.resignFirstResponder()
            return true
        } 
        return true
    }
    
    
    // MARK: - Code For Birthday Picker
    @IBAction func setBirthay(_ sender: UITextField) {
       sender.inputView = datePicker
    }
    
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        birthdate.text = dateFormatter.string(from: sender.date)
    }
    
    
    // MARK: - Register Button Pressed check validation
    @IBAction func registerPressed(_ sender: Any) {
        
        if self.checkValidation() {
            
            activityIndicator.startAnimating()
            
            Auth.auth().createUser(withEmail: emailAddress.text! , password: password.text!) { (user, error) in
                self.activityIndicator.stopAnimating()
                if let error = error{
                    self.alert(message: error.localizedDescription)
                    return
                }
                
                // save data of user
                var ref: DatabaseReference!
                ref = Database.database().reference()
                
                let gendertitle = self.genderSegment.titleForSegment(at: self.genderSegment.selectedSegmentIndex)
                
                let dict = ["firstName":self.firstName.text!,
                            "lastName":self.lastName.text!,
                            "birthdate":self.birthdate.text!,
                            "emailAddress":self.emailAddress.text!,
                            "password":self.password.text!,
                            "gender": gendertitle
                            ]
                
                
                // Saving With Completion
                ref.child("users").child(user!.uid).setValue(dict, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                })
                
                // open next view controller
                self.callAddViewController()
            }
        }
        else{
            // do login
            print("Error with Validation occured")
        }
 
    }
    
    // check validaton of textfield
    func checkValidation() -> Bool {
        
        if (firstName.text?.isEmpty)!{
            firstName.becomeFirstResponder()
            alert(message: "Please Enter your First Name")
            return false
        }
        
        
        if (lastName.text?.isEmpty)!{
            lastName.becomeFirstResponder()
            alert(message: "Please Enter your Last Name")
            return false
        }
        
        if (birthdate.text?.isEmpty)!{
            birthdate.becomeFirstResponder()
            alert(message: "Please Enter your birthdate")
            return false
        }
        
        if genderSegment.selectedSegmentIndex == -1{
            alert(message: "OOps, Please determine your gender")
            return false
        }
        
        if (emailAddress.text?.isEmpty)!{
            emailAddress.becomeFirstResponder()
            alert(message: "Please Enter your Email Address")
            return false
        }
            
        
        if (!self.checkEmailAddress(str: emailAddress.text!)){
            emailAddress.becomeFirstResponder()
            alert(message: "OOPs, Seems like your email Address is not Correct")
            return false
        }
        
        if (password.text?.isEmpty)!{
            password.becomeFirstResponder()
            alert(message: "Please Enter your Password")
            return false
        }
        
        
        if (re_password.text?.isEmpty)!{
            re_password.becomeFirstResponder()
            alert(message: "Please Enter your Password Again")
            return false
        }
        
        if password.text != re_password.text {
            re_password.becomeFirstResponder()
            alert(message: "OOPs, Seems like Passwords are not equals")
            return false
        }
        return true
        
    }
    
    
    func checkEmailAddress(str:String) -> Bool {
        let regExForEmail = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}"
        let checkPredicate = NSPredicate (format: "SELF MATCHES %@", regExForEmail)
        return checkPredicate.evaluate(with:str)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func callAddViewController(){
        
        let addViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddCertificateVC") as! AddCertificateVC
        self.navigationController?.pushViewController(addViewController, animated: true)
    }
    
    
    
    
    // MARK: Keyboard Notifications

    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollview.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollview.contentInset = contentInsets
        self.scrollview.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.currentTextField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollview.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollview.contentInset = contentInsets
        self.scrollview.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollview.isScrollEnabled = false
    }
    
}



