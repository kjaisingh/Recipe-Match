//
//  SingleResult.swift
//  Recipe Match
//
//  Created by Karan Jaisingh on 7/29/18.
//  Copyright © 2018 KaranJaisinghOrg. All rights reserved.
//

import UIKit
import Kingfisher

class SingleResult: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var dishInfo: UITextView!
    @IBOutlet weak var dishLink: UITextView!
    
    @IBOutlet weak var makeThisButton: UIButton!
    @IBOutlet weak var saveThisButton: UIButton!
    
    var dishIndex: Int = 0
    
    // function called upon loading of screen
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // formatting contents of cell and updating data
        dishIndex = globalVariables.selectedDish
        titleLabel.text = globalVariables.dishesResults[dishIndex].getName()
        
        let imageURL = globalVariables.dishesResults[dishIndex].getImageURL()
        let url = URL(string: imageURL)
        dishImage?.kf.indicatorType = .activity
        dishImage?.kf.setImage(with: url)
        
        fillTextFields(index: dishIndex)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // filling text fields to correspond to data of dish
    func fillTextFields(index: Int) {
        
        dishLink.text = globalVariables.dishesResults[index].getRecipeURL()
        
        // accessing each element from Dish object, and storing it in 'text'
        var text: String = ""
        text += "Number of Servings: "
        // accessing using get methods
        text += String(globalVariables.dishesResults[index].getNumServings())
        // adding new lines for code readability
        text += "\n"
        text += "Calories: "
        text += String(globalVariables.dishesResults[index].getCalories())
        text += "\n"
        text += "Diet Preferences: "
        for i in globalVariables.dishesResults[index].getDietPreferences() {
            text += i
            text += ", "
        }
        text = String(text.dropLast())
        text = String(text.dropLast())
        text += "\n"
        text += "Diet Restrictions: "
        for j in globalVariables.dishesResults[index].getDietRestrictions() {
            text += j
            text += ", "
        }
        text = String(text.dropLast())
        text = String(text.dropLast())
        text += "\n"
        text += "\n"
        for k in globalVariables.dishesResults[index].getIngredients() {
            text += k
            text += "\n"
        }
        // setting text of text view to be this 'text' variable
        dishInfo.text? = text
    }

    // function that executes when dish is made
    @IBAction func makeThis(_ sender: Any) {
        
        // get the current date
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        // create object that holds information
        let madeDish = MadeDish(nameResult: globalVariables.dishesResults[dishIndex].getName(), servingsResult: globalVariables.dishesResults[dishIndex].getNumServings(), recipeURLResult: globalVariables.dishesResults[dishIndex].getRecipeURL(), imageURLResult: globalVariables.dishesResults[dishIndex].getImageURL(), caloriesResult: globalVariables.dishesResults[dishIndex].getCalories(), ingredientResults: globalVariables.dishesResults[dishIndex].getIngredients(), dietPreferenceResult: globalVariables.dishesResults[dishIndex].getDietPreferences(), dietRestrictionResult: globalVariables.dishesResults[dishIndex].getDietRestrictions(), givenDay: day!, givenMonth: month!, givenYear: year!)

        globalVariables.userDetails?.setMadeDish(newDish: madeDish)
        
        // disable and edit button
        makeThisButton.isEnabled = false
        let text = "✓ Made"
        makeThisButton.setTitle(text, for: .normal)
        
    }
    
    // function that executes when dish is saved
    @IBAction func saveThis(_ sender: Any) {
        
        // create object with dish details
        let savedDish = Dish(nameResult: globalVariables.dishesResults[dishIndex].getName(), servingsResult: globalVariables.dishesResults[dishIndex].getNumServings(), recipeURLResult: globalVariables.dishesResults[dishIndex].getRecipeURL(), imageURLResult: globalVariables.dishesResults[dishIndex].getImageURL(), caloriesResult: globalVariables.dishesResults[dishIndex].getCalories(), ingredientResults: globalVariables.dishesResults[dishIndex].getIngredients(), dietPreferenceResult: globalVariables.dishesResults[dishIndex].getDietPreferences(), dietRestrictionResult: globalVariables.dishesResults[dishIndex].getDietRestrictions())
        
        globalVariables.userDetails?.setSavedDish(newDish: savedDish)
        
        // disable and edit button
        saveThisButton.isEnabled = false
        let text = "✓ Saved"
        saveThisButton.setTitle(text, for: .normal)

    }
}
