//
//  OpeningScreen.swift
//  Recipe Match
//
//  Created by Karan Jaisingh on 6/25/18.
//  Copyright © 2018 KaranJaisinghOrg. All rights reserved.
//

import UIKit
import FirebaseAuth

class OpeningScreen: UIViewController {

    // function called upon loading of screen
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if no user is logged in, redirect user to home screen
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "goToHome", sender: self)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // buttons to transition to sign up and login pages
    @IBAction func signUpTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "goToSignUp", sender: self)
    }
    @IBAction func loginTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "goToLogin", sender: self)
    }

}
