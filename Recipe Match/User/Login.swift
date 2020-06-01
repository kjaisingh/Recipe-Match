//
//  Login.swift
//  Recipe Match
//
//  Created by Karan Jaisingh on 6/25/18.
//  Copyright © 2018 KaranJaisinghOrg. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class Login: UIViewController, UITextFieldDelegate {

    // function called upon loading of screen
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self

        // Do any additional setup after loading the view.
    }

    // declaration of fields for variables
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // function that logs in a valid user
    @IBAction func loginConfirm(_ sender: Any) {
        // display SVProgressHUD to show progress
        SVProgressHUD.show()
        // function that logs user in
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
            // check whether error present with login details given
            if error != nil{
                if let errCode = AuthErrorCode(rawValue: error!._code){
                    switch errCode {
                    case .wrongPassword:
                        SVProgressHUD.dismiss()
                        self.createAlert(title: "Error Logging In", message: "The password entered is incorrect.")
                        break
                    case .invalidEmail:
                        SVProgressHUD.dismiss()
                        self.createAlert(title: "Error Logging In", message: "The email entered is invalid.")
                        break
                    case .userNotFound:
                        SVProgressHUD.dismiss()
                        self.createAlert(title: "Error Logging In", message: "The specified user account does not exist. Please register.")
                        break
                    case .emailAlreadyInUse:
                        SVProgressHUD.dismiss()
                        self.createAlert(title: "Error Logging In", message: "The specified user is already in use. Please use another email.")
                        break
                    case .weakPassword:
                        SVProgressHUD.dismiss()
                        self.createAlert(title: "Error Logging In", message: "The password entered must be at least 6 characters long.")
                        break
                    default:
                        SVProgressHUD.dismiss()
                        self.createAlert(title: "Error Logging In", message: "There was a connection problem.")
                        break
                    }
                    print(error)
                }
            }
            // if no error, then continue to log user in
            else {
                // dismiss SVProgressHUD upon user creation
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "loginToHome", sender: self)
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
