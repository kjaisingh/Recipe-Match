//
//  SingleHistory.swift
//  Recipe Match
//
//  Created by Karan Jaisingh on 7/30/18.
//  Copyright © 2018 KaranJaisinghOrg. All rights reserved.
//

import UIKit

class SingleHistory: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var dishLink: UITextView!
    @IBOutlet weak var dishInfo: UITextView!
    
    var dishIndex: Int = 0
    
    // function called upon loading of screen
    override func viewDidLoad() {
        super.viewDidLoad()

        dishIndex = globalVariables.selectedDish
        
        titleLabel.text = globalVariables.historyResults[dishIndex].getName()
        
        let imageURL = globalVariables.historyResults[dishIndex].getImageURL()
        let url = URL(string: imageURL)
        dishImage?.kf.indicatorType = .activity
        dishImage?.kf.setImage(with: url)
        
        fillTextFields(index: dishIndex)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // function that fills text fields with key information about dish
    func fillTextFields(index: Int) {
        
        dishLink.text = globalVariables.historyResults[index].getRecipeURL()

        var text: String = ""
        
        text += "Date Created: "
        text += (String(globalVariables.historyResults[index].getDay()) + "/")
        text += (String(globalVariables.historyResults[index].getMonth()) + "/")
        text += String(globalVariables.historyResults[index].getYear())
        text += "\n"
        
        text += "Number of Servings: "
        text += String(globalVariables.historyResults[index].getNumServings())
        text += "\n"
        
        text += "Calories: "
        text += String(globalVariables.historyResults[index].getCalories())
        text += "\n"
        
        text += "Diet Preferences: "
        for i in globalVariables.historyResults[index].getDietPreferences() {
            text += i
            text += ", "
        }
        text = String(text.dropLast())
        text = String(text.dropLast())
        text += "\n"
        
        text += "Diet Restrictions: "
        for j in globalVariables.historyResults[index].getDietRestrictions() {
            text += j
            text += ", "
        }
        text = String(text.dropLast())
        text = String(text.dropLast())
        text += "\n"
        text += "\n"
        
        for k in globalVariables.historyResults[index].getIngredients() {
            text += k
            text += "\n"
        }
        
        dishInfo.text? = text
    }
    

}
