//
//  SignUp.swift
//  Recipe Match
//
//  Created by Karan Jaisingh on 6/25/18.
//  Copyright © 2018 KaranJaisinghOrg. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseAuth
import FirebaseDatabase

// declaration of local variables
public struct defaultsKeys {
    static let keyOne = "emailKey"
    static let keyTwo = "nameKey"
    static let keyThree = "dietPreferenceKey"
    static let keyFour = "dietRestrictionKey"
}

class SignUp: UIViewController, UITextFieldDelegate {

    // declaration of text fields used
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // function called upon loading of screen
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // creation of user upon confirmation
    @IBAction func signUpConfirm(_ sender: Any) {
        // show SVProgressHUD as soon as button tapped
        SVProgressHUD.show()
        // method that creates user
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
            if error != nil{
                // check if an error is present with the inputted values
                if let errCode = AuthErrorCode(rawValue: error!._code){
                    switch errCode {
                    case .invalidEmail:
                        SVProgressHUD.dismiss()
                        self.createAlert(title: "Error Registering", message: "The email entered is invalid.")
                        break
                    case .emailAlreadyInUse:
                        SVProgressHUD.dismiss()
                        self.createAlert(title: "Error Registering", message: "The specified user is already in use. Please use another email.")
                        break
                    case .weakPassword:
                        SVProgressHUD.dismiss()
                        self.createAlert(title: "Error Registering", message: "The password entered must be at least 6 characters long.")
                        break
                    default:
                        SVProgressHUD.dismiss()
                        self.createAlert(title: "Error Registering", message: "There was a connection problem.")
                        break
                    }
                    print(error)
                }
            }
                
            // create user if no errors present
            else {

                var user = Auth.auth().currentUser;
                var uid = user?.uid
                
                // create database reference
                let databaseRef = Database.database().reference()
                // write data to database using reference
                databaseRef.child("Users").child("\(uid!)/Name").setValue(self.nameField.text)
                databaseRef.child("Users").child("\(uid!)/Email").setValue(user?.email)
                databaseRef.child("Users").child("\(uid!)/NumHistory").setValue(0)
                databaseRef.child("Users").child("\(uid!)/NumSaved").setValue(0)
                databaseRef.child("Users").child("\(uid!)/DietPreference").setValue("None")
                databaseRef.child("Users").child("\(uid!)/DietRestriction").setValue("None")
                
                // save important data locally
                let defaults = UserDefaults.standard
                defaults.set(user?.email, forKey: defaultsKeys.keyOne)
                defaults.set(self.nameField.text, forKey: defaultsKeys.keyTwo)
                defaults.set("None", forKey: defaultsKeys.keyThree)
                defaults.set("None", forKey: defaultsKeys.keyFour)
                
                // dismiss SVProgressHUD when user creation done
                SVProgressHUD.dismiss()
                print("User created successfully!")
                self.performSegue(withIdentifier: "signUpToHome", sender: self)
            }
        })
    }
    
    // function that creates an alert given parameters
    func createAlert(title: String, message: String) {
        let errormsg = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        errormsg.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler:  { (action) in
            errormsg.dismiss(animated: true, completion: nil)
        }))
        self.present(errormsg, animated: true, completion: nil)
    }
    
    // function to check whether a text field should return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // function to check whether a user has begun typing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
