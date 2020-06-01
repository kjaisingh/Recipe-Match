//
//  Dish.swift
//  Recipe Match
//
//  Created by Karan Jaisingh on 6/25/18.
//  Copyright © 2018 KaranJaisinghOrg. All rights reserved.
//

import Foundation

class Dish {
    
    var name: String = ""
    var numServings: Int = 0
    var recipeURL: String = ""
    var imageURL: String = ""
    var calories: Int = 0
    var ingredients: [String] = []
    var dietPreferenceLabels: [String] = [] // this is different from the UML diagram
    var dietRestrictionLabels: [String] = [] // this is different from the UML diagram
    
    // constructor to intialize a dish
    init(nameResult: String, servingsResult: Int, recipeURLResult: String, imageURLResult: String, caloriesResult: Int, ingredientResults: [String], dietPreferenceResult: [String], dietRestrictionResult: [String]) {
        
        name = nameResult
        numServings = servingsResult
        recipeURL = recipeURLResult
        imageURL = imageURLResult
        calories = caloriesResult
        ingredients = ingredientResults
        dietPreferenceLabels = dietPreferenceResult
        dietRestrictionLabels = dietRestrictionResult
        
    }
    
    // function to retrieve 'name' field
    func getName()->String {
        return name
    }
    
    // function to retrieve 'numServings' field
    func getNumServings()->Int {
        return numServings
    }
    
    // function to retrieve 'recipeURL' field
    func getRecipeURL()->String {
        return recipeURL
    }
    
    // function to retrieve 'imageURL' field
    func getImageURL()->String {
        return imageURL
    }
    
    // function to retrieve 'calories' field
    func getCalories() -> Int {
        return calories
    }
    
    // function to retrieve 'ingredients' field
    func getIngredients() -> [String] {
        return ingredients
    }
    
    // function to retrieve 'dietPreferenceLabels' field
    func getDietPreferences() -> [String] {
        return dietPreferenceLabels
    }
    
    // function to retrieve 'dietRestrictionLabel' field
    func getDietRestrictions() -> [String] {
        return dietRestrictionLabels
    }
    
}
