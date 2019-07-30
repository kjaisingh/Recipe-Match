//
//  SingleSaved.swift
//  Recipe Match
//
//  Created by Karan Jaisingh on 7/30/18.
//  Copyright © 2018 KaranJaisinghOrg. All rights reserved.
//

import UIKit

class SingleSaved: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var dishLink: UITextView!
    @IBOutlet weak var dishInfo: UITextView!
    
    var dishIndex: Int = 0
    @IBOutlet weak var makeThisButton: UIButton!
    
    // function called upon loading of screen
    override func viewDidLoad() {
        super.viewDidLoad()

        dishIndex = globalVariables.selectedDish
        
        titleLabel.text = globalVariables.savedResults[dishIndex].getName()
        
        let imageURL = globalVariables.savedResults[dishIndex].getImageURL()
        let url = URL(string: imageURL)
        dishImage?.kf.indicatorType = .activity
        dishImage?.kf.setImage(with: url)
        
        fillTextFields(index: dishIndex)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // fill text field with important details about the dish
    func fillTextFields(index: Int) {
        
        dishLink.text = globalVariables.savedResults[index].getRecipeURL()
        
        var text: String = ""
        
        text += "Number of Servings: "
        text += String(globalVariables.savedResults[index].getNumServings())
        text += "\n"
        
        text += "Calories: "
        text += String(globalVariables.savedResults[index].getCalories())
        text += "\n"
        
        text += "Diet Preferences: "
        for i in globalVariables.savedResults[index].getDietPreferences() {
            text += i
            text += ", "
        }
        text = String(text.dropLast())
        text = String(text.dropLast())
        text += "\n"
        
        text += "Diet Restrictions: "
        for j in globalVariables.savedResults[index].getDietRestrictions() {
            text += j
            text += ", "
        }
        text = String(text.dropLast())
        text = String(text.dropLast())
        text += "\n"
        text += "\n"
        
        for k in globalVariables.savedResults[index].getIngredients() {
            text += k
            text += "\n"
        }
        
        dishInfo.text? = text
    }
    
    // make dish if button tapped
    @IBAction func makeThisTapped(_ sender: Any) {
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        let madeDish = MadeDish(nameResult: globalVariables.savedResults[dishIndex].getName(), servingsResult: globalVariables.savedResults[dishIndex].getNumServings(), recipeURLResult: globalVariables.savedResults[dishIndex].getRecipeURL(), imageURLResult: globalVariables.savedResults[dishIndex].getImageURL(), caloriesResult: globalVariables.savedResults[dishIndex].getCalories(), ingredientResults: globalVariables.savedResults[dishIndex].getIngredients(), dietPreferenceResult: globalVariables.savedResults[dishIndex].getDietPreferences(), dietRestrictionResult: globalVariables.savedResults[dishIndex].getDietRestrictions(), givenDay: day!, givenMonth: month!, givenYear: year!)
        
        globalVariables.userDetails?.setMadeDish(newDish: madeDish)
        
        makeThisButton.isEnabled = false
        let text = "✓ Made"
        makeThisButton.setTitle(text, for: .normal)
        
    }
    
}
