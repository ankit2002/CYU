//
//  RegisterStudentViewController.swift
//  CYU
//
//  Created by Ankit Mishra on 09/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit

class RegisterStudentViewController: UIViewController,UITextFieldDelegate {

    // MARK: Defining Variables
    let datePicker :UIDatePicker = UIDatePicker()
    
    // MARK: Defining Outlet Variables
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var birthdate: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var re_password: UITextField!
    
    @IBOutlet weak var scrollview: UIScrollView!
    var currentTextField : UITextField!
    
    
    // This constraint ties an element at zero points from the bottom layout guide
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    
    override func viewWillAppear(_ animated: Bool) {
        setupViewResizerOnKeyboardShown();
    }
    
    
    
    
    // MARK: - System Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // datePicker Works
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
    
    
    // removing Notification Centre
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
        
        if textField == birthdate{
            
        }
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
                alert(message: "Please Enter your birthdate Name")
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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




extension UIViewController{
    func alert(message:String, title:String = ""){

        let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction (title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}



























