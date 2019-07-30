//
//  History.swift
//  Recipe Match
//
//  Created by Karan Jaisingh on 6/25/18.
//  Copyright © 2018 KaranJaisinghOrg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class History: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var totalCalData: UILabel!
    @IBOutlet weak var recentCalData: UILabel!
    
    var recentCals: [Int] = []
    var recentServings: [Int] = []
    var totalCals: Int = 0
    var year: Int = 0
    var month: Int = 0
    var day: Int = 0
    
    var num: Int = 0
    
    // function called upon loading of screen
    override func viewDidLoad() {
        
        super.viewDidLoad()
        recentCals = []
        totalCals = 0
        
        // get current date data
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        year =  components.year!
        month = components.month!
        day = components.day!
        
        let user = Auth.auth().currentUser;
        let uid = user?.uid
        globalVariables.historyResults = []
        downloadMadeDishes(user: uid!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    // function that downloads made dishes from database
    func downloadMadeDishes(user: String) {
        
        // create database reference to access database
        let databaseRef = Database.database().reference().child("Users").child("\(user)").child("MadeDishes")
        // observe method for getting data from database
        databaseRef.observe(.childAdded, with: { (snapshot) in
            // parse data from database into Dictionary format
            let snapshotValue = snapshot.value as! Dictionary<String, Any>
            // read values from this dictionary using dictionary keys
            let dishName = snapshotValue["Name"] as! String
            print(dishName)
            let dishServings = snapshotValue["Number of Servings"] as! Int
            let dishRecipeURL = snapshotValue["Recipe URL"] as! String
            let dishImageURL = snapshotValue["Image URL"] as! String
            let dishCalories = snapshotValue["Calories"] as! Int
            let dishIngredients = snapshotValue["Ingredients"] as! [String]
            let dishDietPreferences = snapshotValue["Diet Preferences"] as! [String]
            let dishDietRestrictions = snapshotValue["Diet Restrictions"] as! [String]
            let dishDay = snapshotValue["Day"] as! Int
            let dishMonth = snapshotValue["Month"] as! Int
            let dishYear = snapshotValue["Year"] as! Int
            
            let historyDish = MadeDish(nameResult: dishName, servingsResult: dishServings, recipeURLResult: dishRecipeURL, imageURLResult: dishImageURL, caloriesResult: dishCalories, ingredientResults: dishIngredients, dietPreferenceResult: dishDietPreferences, dietRestrictionResult: dishDietRestrictions, givenDay: dishDay, givenMonth: dishMonth, givenYear: dishYear)
            
            globalVariables.historyResults.append(historyDish)
            
            // initialize variables
            let daysPerMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
            var recent: Bool = false
            var currDaysInYear: Int = 0
            var dishDaysInYear: Int = 0
            
            // FOR CURRENT DAY IN YEAR:
            // add number of days for each month completely completed
            for i in 0...(self.month - 2) {
                currDaysInYear += daysPerMonth[i]
            }
            // add number of days surpassed in month
            currDaysInYear += self.day
            
            // FOR DAY IN YEAR OF DISH:
            // add number of days for each month completely completed
            for i in 0...(dishMonth - 2) {
                dishDaysInYear += daysPerMonth[i]
            }
            // add number of days surpassed in month
            dishDaysInYear += dishDay
            
            // add 365 to the current day in year if dish was made in the previous year
            if(self.year != dishYear) {
                currDaysInYear += 365
            }
            
            // set recent to true if the difference in days is less than 14 (two weeks)
            if((currDaysInYear - dishDaysInYear) > 14) {
                recent = false
            } else {
                recent = true
            }
            
            if(recent) {
                self.recentCals.append(dishCalories)
                self.recentServings.append(dishServings)
            }
            self.totalCals += dishCalories
            
            self.recentCalData.text = String(describing: self.getAverage(calories: self.recentCals, servings: self.recentServings)) + " cal"
            self.totalCalData.text = String(describing: self.totalCals) + " cal"
            
            self.historyTableView.reloadData()
            
        })
        
    }
    
    // set number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalVariables.historyResults.count
    }
    
    // customize each cell in table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        num = globalVariables.historyResults.count - 1
        
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let cellText = globalVariables.historyResults[num - indexPath.row].getName()
        cell.textLabel?.text = cellText
        
        // set cell subtitle to contain ingredients
        let ingredientsArray = globalVariables.historyResults[num - indexPath.row].getIngredients()
        var cellSubtitle: String = ""
        for ingredient in ingredientsArray {
            cellSubtitle += ingredient
            cellSubtitle += "; "
        }
        cellSubtitle = String(cellSubtitle.dropLast())
        cellSubtitle = String(cellSubtitle.dropLast())
        cell.detailTextLabel?.text = cellSubtitle
        
        // add image to cell
        let cellURL = globalVariables.historyResults[num - indexPath.row].getImageURL()
        let url = URL(string: cellURL)
        cell.imageView?.kf.indicatorType = .activity
        cell.imageView?.kf.setImage(with: url, completionHandler: {
            (image, error, cacheType, imageUrl) in
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        })
        
        return cell
        
    }
    
    // function executed when a cell is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        globalVariables.selectedDish = num - indexPath.row
        performSegue(withIdentifier: "goToSingle", sender: self)
    }
    
    // customize size of cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    // get average calories of dish based on number of servings
    func getAverage(calories: [Int], servings: [Int]) -> Int {
        var avg: Int = 0
        if(calories.count > 0) {
            for i in 0...(calories.count - 1) {
                avg += Int(calories[i] / servings[i])
            }
            avg = Int(avg / calories.count)
        }
        return avg
    }

}
