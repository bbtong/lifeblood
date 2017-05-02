//
//  LoginViewController.swift
//  Lifeblood
//
//  Created by Bryan Tong on 4/13/17.
//  Copyright © 2017 btong. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    //
    //btn.layer.cornerRadius = 10
    //btn.clipsToBounds = true
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
    }

    
    override func viewDidAppear(_ animated: Bool) {
        // Checks if user is already signed in and skips login
        if FIRAuth.auth()?.currentUser != nil {
            self.performSegue(withIdentifier: "loginToMain", sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func didAttemptLogin(_ sender: UIButton) {
        guard let emailText = emailField.text else { return }
        guard let passwordText = passwordField.text else { return }
        // My login code below
        FIRAuth.auth()?.signIn(withEmail: emailText, password: passwordText, completion: { (user, error) in
            if error != nil {
                // If fails, display an alert message to try login again.
                let alert = UIAlertController(title: "Sign-in Failed", message: "Sign-in failed, please try again.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "loginToMain", sender: self)
            }
        })
    }
    
    @IBAction func didNeedSignup(_ sender: Any) {
        self.performSegue(withIdentifier: "loginToSignup", sender: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}
