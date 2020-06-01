//
//  Profile.swift
//  Recipe Match
//
//  Created by Karan Jaisingh on 6/25/18.
//  Copyright © 2018 KaranJaisinghOrg. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class Profile: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var dietPreferencePicker: UIPickerView!
    @IBOutlet weak var dietRestrictionPicker: UIPickerView!
    
    // arrays that store diet preference and diet restriction options
    var dietPreferenceOptions = ["None", "Balanced", "High Fiber", "High Protein", "Low Carbs", "Low Fat", "Low Sodium"]
    var dietRestrictionOptions = ["None", "Dairy Free", "Eggs Free", "Gluten Free", "No Sugar", "Peanut Free", "Vegan", "Vegatarian"]
    
    var currName: String = ""
    var currEmail: String = ""
    var currDietPreference = ""
    var currDietRestriction = ""
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    // function called upon loading of screen
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        nameField.delegate = self
        emailField.delegate = self
        
        nameField.text = globalVariables.userDetails?.getName()
        emailField.text = globalVariables.userDetails?.getEmail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // set number of components in table view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // set number of rows in picker view to be the number of rows in the arrays
    // tag 1 corresponds to the diet preference picker
    // tag 2 corresponds to the diet restriction picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count = 0
        if(pickerView.tag == 1) {
            count = dietPreferenceOptions.count
        } else if(pickerView.tag == 2) {
            count = dietRestrictionOptions.count
        }
        return count
    }
    
    // set the text for each row in the picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1) {
            return dietPreferenceOptions[row]
        } else if(pickerView.tag == 2) {
            return dietRestrictionOptions[row]
        }
        return ""
    }
    
    // performs function upon the selection of a row in the picker view
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1) {
             currDietPreference = dietPreferenceOptions[row]
        } else if(pickerView.tag == 2) {
            currDietRestriction = dietRestrictionOptions[row]
        }
    }

    // update the user details when the corresponding button is tapped
    @IBAction func updateDetails(_ sender: Any) {
        
        globalVariables.userDetails?.setName(newName: nameField.text!)
        globalVariables.userDetails?.setEmail(newEmail: emailField.text!)
        globalVariables.userDetails?.setDietPreference(newDietPreference: currDietPreference)
        globalVariables.userDetails?.setDietRestriction(newDietRestriction: currDietRestriction)
        
        var user = Auth.auth().currentUser;
        var uid = user?.uid
        
        globalVariables.userDetails?.updateProfileDetails(userID: uid!)
        
        self.createAlert(title: "Successfully updated!", message: "User details have been updated for your account.")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    // dismiss text field when editing done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // check whether the text field is being edited
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // function that creates an alert given parameters
    func createAlert(title: String, message: String) {
        let errormsg = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        errormsg.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler:  { (action) in
            errormsg.dismiss(animated: true, completion: nil)
        }))
        self.present(errormsg, animated: true, completion: nil)
    }

}
