//
//  AddCertificateVC.swift
//  CYU
//
//  Created by Ankit Mishra on 06/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class AddCertificateVC: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    //MARK: Properties
    var parentStr = String()
    let datePicker = UIDatePicker()
    var imagePicker = UIImagePickerController()
    var imageData : NSData?
    var dataForUpdation : CourseStructure!
    var isVerifiable = false
    var keyForUpdation = String()
    
    //MARK: Outlet Properties
    @IBOutlet weak var courseNameTxt: UITextField!
    @IBOutlet weak var completionDateTxt: UITextField!
    @IBOutlet weak var degreeImagePreview: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addDegreeBtn: CustomRoundButton!
    @IBOutlet weak var addDegreeImageBtn: CustomRoundButton!
    @IBOutlet weak var doneBarItemBtn: UIBarButtonItem!
    @IBOutlet weak var askForVerificationBtn: CustomRoundButton!
    @IBOutlet weak var uniNameTxt: UITextField!
    @IBOutlet weak var verifiableSwitch: UISwitch!    
    @IBOutlet weak var placeHolderLbl: UILabel!
    
    
    //MARK: System Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.askForVerificationBtn.isEnabled = false
        askForVerificationBtn.backgroundColor = UIColor.lightGray
        placeHolderLbl.isHidden = false
        
        
        // set Delegate
        imagePicker.delegate = self
        
        // create datePicker
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
        completionDateTxt.inputView = datePicker
        
        // hide keyboard when tap arround
        hideKeyboardWhenTappedArround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let navController = self.navigationController, navController.viewControllers.count >= 2 {
            let viewController = navController.viewControllers[navController.viewControllers.count - 2]
            
            if viewController.isKind(of: ShowDocumentViewController.self){
                parentStr = "ShowDoc"
                self.navigationItem.hidesBackButton = false
                doneBarItemBtn.isEnabled = false
                
                if let data = dataForUpdation {
                    
                    // Fetch Image From Firebase
                    fetchImageFromFirebaseStorage(urlString:data.courseUrl)
                    //Set Data
                    courseNameTxt.text = data.courseName
                    completionDateTxt.text = data.courseCompletionDate
                    uniNameTxt.text = data.uniName
                    
                    if data.isVerifiable{
                        verifiableSwitch.isOn = true
                        self.askForVerificationBtn.isEnabled = true
                        self.askForVerificationBtn.backgroundColor = UIColor (red: 44, green: 166, blue: 255)
                    }
                    else{
                        verifiableSwitch.isOn = false
                        askForVerificationBtn.isEnabled = false
                        askForVerificationBtn.backgroundColor = UIColor.lightGray
                    }

                    addDegreeBtn.setTitle("Update Data", for: .normal)
                    
                    
                    if data.isVerified || data.AskForVerification {
                        disableAllInputFields()
                    }
                    else{
                        addDegreeBtn.backgroundColor = UIColor (red: 44, green: 166, blue: 255)
                        
                    }
                }
            }
            else{
                parentStr = "Register"
                self.navigationItem.hidesBackButton = true
            }
        }
    }
    
    //MARK: Disable all Fields
    func disableAllInputFields(){
        
        courseNameTxt.isEnabled = false
        completionDateTxt.isEnabled = false
        uniNameTxt.isEnabled = false
        addDegreeImageBtn.isEnabled = false
        addDegreeImageBtn.backgroundColor = UIColor.lightGray
        addDegreeBtn.isEnabled = false
        addDegreeBtn.backgroundColor = UIColor.lightGray
        askForVerificationBtn.isEnabled = false
        askForVerificationBtn.backgroundColor = UIColor.lightGray
        verifiableSwitch.isEnabled = false
    }
    
    //MARK: Method to Fetch Image from Server
    func fetchImageFromFirebaseStorage(urlString:String){
        
        startSpinnerAndStopInteraction()
        
        let storageRef = Storage.storage().reference(forURL: urlString)
        
        storageRef.downloadURL(completion: { (url, error) in
            
            if let e = error {
                print(e.localizedDescription as Any)
            }
            else{
                let data = NSData(contentsOf: url!)
                let image = UIImage(data: data! as Data)
                self.degreeImagePreview.image = image
                self.imageData = data
                self.placeHolderLbl.isHidden = true
            }
            
            self.stopSpinnerAndResumeInteraction()
        })
    }
    
    
    //MARK: Datepicker Date Formetor work
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        completionDateTxt.text = dateFormatter.string(from: sender.date)
    }
    
    //MARK: Set Date in TextField
    @IBAction func setDegreeCompletionDate(_ sender: UITextField) {
        sender.inputView = datePicker
    }
    
    
    //MARK: Add Degree Btn Pressed
    @IBAction func AddDegreeBtnPressed(_ sender: Any) {
        // After saving clear data
        if validateData(){
            uploadImageWithData()
        }
    }
    
    
    //MARK:- Save Data in User AccountFirebase
    func saveDataInFirebase(imageUrl:String, userID:String) {
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("/users/\(userID)/DegreeImage/")
        
        let dict = ["Course Name": courseNameTxt.text!, "Completion Year": completionDateTxt.text!,"isVerified":false,"AskForVerification":false, "degreeImageURL":imageUrl,"University Name":uniNameTxt.text!, "isVerifiable":isVerifiable] as [String:Any]
        
        
//        let updateData = ["\(key)":dict,"/StudentVerificationFromUni/\(key)":dict]

        ref.childByAutoId().setValue(dict, withCompletionBlock: { (error, ref) in
            if error == nil {
                if self.isVerifiable{
                    self.saveInUniVerificationList(data:dict,iD:userID,keyData:ref.key)
                }
                else{
                    self.clearAllFields()
                    self.alert(message: "Data Saved Successfully")
                }
            }else{
                print(error?.localizedDescription as Any)
                self.alert(message: "OOps Something went wrong")
            }
            self.stopSpinnerAndResumeInteraction()
        })
    }
    
    //MARK:- Save Data in Uni Account Firebase
    func saveInUniVerificationList(data:[String:Any],iD:String,keyData:String){

        var ref: DatabaseReference!
        ref = Database.database().reference().child("StudentVerificationFromUni/\(keyData)")
        
        let dict = ["Course Name": data["Course Name"] as! String , "Completion Year": data["Completion Year"] as! String,"isVerified":data["isVerified"] as! Bool,"AskForVerification":data["AskForVerification"] as! Bool, "degreeImageURL":data["degreeImageURL"] as! String,"University Name":data["University Name"] as! String, "StudentID":iD ] as [String:Any]
        
        ref.setValue(dict, withCompletionBlock: { (error, ref) in
            if error == nil {
                self.clearAllFields()
                self.alert(message: "Data Saved Successfully")
            }else{
                print(error?.localizedDescription as Any)
                self.alert(message: "OOps Something went wrong")
            }
        })
    }
    
    //MARK: Method to upload Image in Firebase Storage using data
    func uploadImageWithData(){
        
        startSpinnerAndStopInteraction()
        
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        
        // Create a root reference
        let storageRef = storage.reference().child("DocImages")
        
        
        // get user ID
        let userID = Auth.auth().currentUser!.uid
        
        // Create a reference to the file you want to upload
        let fileRef = storageRef.child("\(userID)/\(courseNameTxt.text!).jpg")
        
        // Upload the file to the path "images/rivers.jpg"
        fileRef.putData(imageData! as Data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                self.alert(message: "Could not upload Image")
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL = metadata.downloadURL()?.absoluteString
//            let str = downloadURL()?.absoluteString
            self.saveDataInFirebase(imageUrl:downloadURL!, userID:userID)
        }
    }
    
    
    //MARK: Clear All Data
    func clearAllFields(){
        
        courseNameTxt.text = nil
        completionDateTxt.text = nil
        uniNameTxt.text = nil
        degreeImagePreview.image = nil
        placeHolderLbl.isHidden = false
        verifiableSwitch.isOn = false
        askForVerificationBtn.isEnabled = false
        askForVerificationBtn.backgroundColor = UIColor.lightGray
    }
    
    
    //MARK: Validate Data
    func validateData() -> Bool {
        
        if (courseNameTxt.text?.isEmpty)! {
            courseNameTxt.becomeFirstResponder()
            alert(message: "Have you Entered Degree Name", title: "OOPs")
            return false
        }
        
        if (completionDateTxt.text?.isEmpty)! {
            completionDateTxt.becomeFirstResponder()
            alert(message: "Have you Entered Degree Completion Date?", title: "OOPs")
            return false
        }
        
        if degreeImagePreview.image == nil {
            alert(message: "Have you added the Image", title: "OOPs")
            return false
        }
        
        if (uniNameTxt.text?.isEmpty)!{
            alert(message: "Have you Entered UniVersity Name", title: "OOPs")
            courseNameTxt.becomeFirstResponder()
            return false
        }
        
        return true
    }
    
    //MARK: Dismiss view controller -- Done Pressed
    @IBAction func dismissVC(){
        
        if parentStr == "Register"{
            openStudentHomeVC()
        }
        else{
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        }
    }
    
    //MARK: Add Degree Image Button Pressed -- Camera And Gallery Work
    @IBAction func addDegreeImageBtnPressed(_ sender: Any) {
        
        // open image Picker for camera and
        let alertView = UIAlertController (title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alertView.addAction(UIAlertAction (title: "Gallery", style: .default, handler: { _ in
            self.openDeviceGallary()
        }))
        
        alertView.addAction(UIAlertAction (title: "Camera", style: .default, handler: { _ in
            self.openDeviceCamera()
            ()
        }))
        
        alertView.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    // Camera Work
    func openDeviceCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController (title: "OOPs", message: "Something wrong with camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction (title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Gallery Work
    func openDeviceGallary()
    {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    //MARK:- UIImagePickerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//        degreeImagePreview.contentMode = .scaleAspectFill
        
        // Check for URL
        imageData = UIImagePNGRepresentation(chosenImage)! as NSData
        
        degreeImagePreview.image = chosenImage
        placeHolderLbl.isHidden = true
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    //MARK: UITextField Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == courseNameTxt){
            if (textField.text?.isEmpty)!{
                alert(message: "Please Enter Course Name")
                return false;
            }
            
            // Error Check next tag failed
            let nextTextField:UITextField = self.view.viewWithTag(textField.tag+1) as! UITextField
            nextTextField.becomeFirstResponder()
            return true
        }
        if(textField == completionDateTxt){
            if (textField.text?.isEmpty)!{
                alert(message: "Please Enter your Degree completion Year")
                return false;
            }
            textField.resignFirstResponder()
            return true
        }
        return true
    }
    
    
    
    //MARK: Open home View
    func openStudentHomeVC() {
        
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
    
    
    //MARK: startSpinnerAndStopInteraction
    func startSpinnerAndStopInteraction(){
        DispatchQueue.main.async {
            UIApplication.shared.beginIgnoringInteractionEvents()
            self.activityIndicator.startAnimating()
        }
    }
    
    
    // stopSpinnerAndResumeInteraction
    func stopSpinnerAndResumeInteraction(){
        DispatchQueue.main.async {
            UIApplication.shared.endIgnoringInteractionEvents()
            self.activityIndicator.stopAnimating()
        }
    }

    //MARK:- Is 
    @IBAction func switchChanged(_ sender: Any) {
        
        if verifiableSwitch.isOn{
            
            isVerifiable = true
        }
        else{
            
            isVerifiable = false
        }
        
    }
    
    
    // MARK: Ask for Verification of Degree
    @IBAction func askForVerificationBtnPressed(_ sender: Any) {
        showAlert(message: "Are you sure for verification? This Cannot be Revert!!")
    }
    
    private func showAlert(message:String, title:String = "") {
        let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction (title: "OK", style: .default, handler: { action in
            self.updateDataForVerificationInFirebase()
        })
        let cancelAction = UIAlertAction (title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Update Field and ask for verification
    func updateDataForVerificationInFirebase()  {
        disableAllInputFields()
        
        let userID = Auth.auth().currentUser!.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let key = keyForUpdation
        print(key)

        let dict = ["Course Name": dataForUpdation.courseName, "Completion Year": dataForUpdation.courseCompletionDate,"isVerified":dataForUpdation.isVerified,"AskForVerification":true ,  "degreeImageURL":dataForUpdation.courseUrl,"University Name":dataForUpdation.uniName, "isVerifiable":dataForUpdation.isVerifiable] as [String:Any]
        
        let unidict = ["Course Name": dataForUpdation.courseName, "Completion Year": dataForUpdation.courseCompletionDate,"isVerified":dataForUpdation.isVerified,"AskForVerification":true ,  "degreeImageURL":dataForUpdation.courseUrl,"University Name":dataForUpdation.uniName, "StudentID":userID] as [String:Any]
        
        let updateData = ["/users/\(userID)/DegreeImage/\(key)":dict,"/StudentVerificationFromUni/\(key)":unidict]
        ref.updateChildValues(updateData) { (error, inref) in
            if error == nil {
                self.alert(message: "Request Send For Verification")
            }
            else{
                print(error?.localizedDescription as Any)
            }
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
