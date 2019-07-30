//
//  GlobalVariables.swift
//  Recipe Match
//
//  Created by Karan Jaisingh on 7/27/18.
//  Copyright © 2018 KaranJaisinghOrg. All rights reserved.
//

import Foundation

// holds global variables
struct globalVariables {
    
    // instance of UserDetails class that stores current user details
    static var userDetails: UserDetails?
    
    // arrays to hold high and low priority ingredients
    static var highPriority: [String] = []
    static var lowPriority: [String] = []
    
    // priorityChoice = 1 if high priority tapped
    // priorityChoice = 2 if low priority tapped
    static var priorityChoice = 0
    
    // array to hold returned dishes
    static var dishesResults = [Dish]()
    
    // array to hold previously made dishes
    static var historyResults = [MadeDish]()
    
    // array to hold saved dishes
    static var savedResults = [Dish]()
    
    // reference counter variable
    static var selectedDish: Int = 0
    
}
