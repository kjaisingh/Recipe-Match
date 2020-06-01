//
//  Search.swift
//  Recipe Match
//
//  Created by Karan Jaisingh on 6/25/18.
//  Copyright © 2018 KaranJaisinghOrg. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class Search: UIViewController {

    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var textFieldLow: UITextView!
    @IBOutlet weak var customField: UITextField!
    
    // function called upon loading of screen
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true);

        let user = Auth.auth().currentUser;
        let email = user?.email
        let uid = user?.uid
        
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.green.cgColor
        textField.layer.cornerRadius = 15.0
        textFieldLow.layer.borderWidth = 1.0
        textFieldLow.layer.borderColor = UIColor.green.cgColor
        textFieldLow.layer.cornerRadius = 15.0
        
        globalVariables.userDetails = UserDetails(userEmail: email!, userID: uid!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOutTapped))
        fillTextView()
    }
    
    // function to sign out user when corresponding button pressed
    @objc func signOutTapped() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("There was an error signing out.")
        }
        
        guard(navigationController?.popToRootViewController(animated: true)) != nil
            else {
                print("To view controllers to pop off")
                //return array of all view controllers popped off
                return
        }
    }

    // functions that perform segues to ingredient lists depending on whether high/low priority tapped
    @IBAction func highPriorityTapped(_ sender: Any) {
        globalVariables.priorityChoice = 1
        self.performSegue(withIdentifier: "goToIngredients", sender: self)
    }
    @IBAction func lowPriorityTapped(_ sender: Any) {
        globalVariables.priorityChoice = 2
        self.performSegue(withIdentifier: "goToIngredients", sender: self)
    }
    
    // function that resets ingredients
    @IBAction func resetIngredients(_ sender: Any) {
        globalVariables.highPriority = []
        globalVariables.lowPriority = []
        
        textField.text = ""
        textFieldLow.text = ""
    }
    
    // function that adds custom high priority ingredient
    @IBAction func customHighPressed(_ sender: Any) {
        let ingredient = customField.text
        globalVariables.highPriority.append(ingredient!)
        customField.text = ""
        fillTextView()
    }
    
    // function that adds custom low priority ingredient
    @IBAction func customLowPressed(_ sender: Any) {
        let ingredient = customField.text
        globalVariables.lowPriority.append(ingredient!)
        customField.text = ""
        fillTextView()
    }
    
    // progress to look for recipes
    @IBAction func findPressed(_ sender: Any) {
        globalVariables.dishesResults = []
        self.performSegue(withIdentifier: "performSearch", sender: self)
    }
    
    // fill details of text view displaying ingredients inputted
    func fillTextView() {
        // initialize string variable
        var filledTextField = ""
        var filledTextFieldLow = ""
        // loop through high prirotiy ingredients array
        for i in globalVariables.highPriority {
            filledTextField += i
            filledTextField += "\n"
        }
        // loop through low prirotiy ingredients array
        for i in globalVariables.lowPriority {
            filledTextFieldLow += i
            filledTextFieldLow += "\n"
        }
        // set text field properties
        textField.text = filledTextField
        textFieldLow.text = filledTextFieldLow
    }
    
}
