//
//  MadeDish.swift
//  Recipe Match
//
//  Created by Karan Jaisingh on 6/25/18.
//  Copyright © 2018 KaranJaisinghOrg. All rights reserved.
//

import Foundation

class MadeDish: Dish {
    
    // declaration of variables needed to know date of creation
    var day: Int = 0
    var month: Int = 0
    var year: Int = 0
    
    // constructor that initalizes dish
    init(nameResult: String, servingsResult: Int, recipeURLResult: String, imageURLResult: String, caloriesResult: Int, ingredientResults: [String], dietPreferenceResult: [String], dietRestrictionResult: [String], givenDay: Int, givenMonth: Int, givenYear: Int) {
        
        // calls upon the superclass constructor
        super.init(nameResult: nameResult, servingsResult: servingsResult, recipeURLResult: recipeURLResult, imageURLResult: imageURLResult, caloriesResult: caloriesResult, ingredientResults: ingredientResults, dietPreferenceResult: dietPreferenceResult, dietRestrictionResult: dietRestrictionResult)
        day = givenDay
        month = givenMonth
        year = givenYear
        
    }
    
    // retrieve day
    func getDay() -> Int {
        return day
    }
    
    // retrieve month
    func getMonth() -> Int {
        return month
    }
    
    // retrieve year
    func getYear() -> Int {
        return year
    }
    
}
