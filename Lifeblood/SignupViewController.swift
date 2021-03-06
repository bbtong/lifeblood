//
//  SignupViewController.swift
//  Lifeblood
//
//  Created by Bryan Tong on 4/13/17.
//  Copyright © 2017 btong. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SignupViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let bloodTypes = ["O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-"]
    var bloodType: String = ""

    /* Sets up all of the IBOutlets for the fields. */
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var bloodTypeField: UIPickerView!
    @IBOutlet weak var purposeField: UISegmentedControl!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    /* Picker setup. */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bloodTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bloodTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bloodType = bloodTypes[row]
    }
    
    /* Sets up button fields*/
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        ageField.delegate = self
        bloodTypeField.delegate = self
        bloodTypeField.dataSource = self
        //purposeField.delegate = self
        locationField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    /* Signs up or fails */
    @IBAction func didAttemptSignup(_ sender: UIButton) {
        guard let name = nameField.text else { return }
        guard let age = ageField.text else { return } // replace with AGE VERIFIER
        let bloodType = bloodTypes[bloodTypeField.selectedRow(inComponent: 0)]
        let purpose = purposeField.isEnabledForSegment(at: 0) // true is donating, false is receiving
        guard let location = Int(locationField.text!) else { return } // REPLACE WITH GOOGLE MAPS API OR ZIP CODE SYSTEM
        let userMaxLocation = location + 500
        let userMinLocation = location - 500
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }
        if (Int(age)! < 18) {
            let ageAlert = UIAlertController(title: "Legal Age Only", message: "You must be 18 or older to use this app and legally donate blood without a parent/guardian.", preferredStyle: UIAlertControllerStyle.alert)
            ageAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(ageAlert, animated: true, completion: nil)
        }
        
        // Password verifier
        if (password.characters.count < 8) {
            let passAlert = UIAlertController(title: "Password Too Short", message: "Your password must be 8 characters or more.", preferredStyle: UIAlertControllerStyle.alert)
            passAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(passAlert, animated: true, completion: nil)
        }
        // My sign up code below
        _ = FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            /*user!.name = name
            user!.age = age
            user!.maxLocation = userMaxLocation
            user!.minLocation = userMinLocation
            user!.blood = bloodType*/
            if error != nil {
                // If fails, display an alert message to try login again.
                let alert = UIAlertController(title: "Sign-up Failed", message: "Signing up failed, please try again.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let changeRequest = user!.profileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges(completion: { (err) in
                    if let err = err {
                        print(err)
                    } else {
                        self.performSegue(withIdentifier: "signupToMain", sender: self)
                    }
                })
            }
        } )
        let ref = FIRDatabase.database().reference()
        let rootChild = ref.child("users")
        /* Borrowed from Stack Overflow user William Hu. */
        let uidChild = email.lowercased().replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
        let userChild = rootChild.child(uidChild)
        userChild.child("name").setValue(name)
        userChild.child("age").setValue(age)
        userChild.child("zipcode").setValue(location)
        userChild.child("maxZip").setValue(userMaxLocation)
        userChild.child("minZip").setValue(userMinLocation)
        userChild.child("bloodType").setValue(bloodType)
        userChild.child("purpose").setValue(purpose)
        userChild.child("email").setValue(email)
    }
    
    @IBAction func didAlreadySignup(_ sender: Any) {
        self.performSegue(withIdentifier: "signupToLogin", sender: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    
}
