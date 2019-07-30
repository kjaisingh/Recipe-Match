//
//  Saved.swift
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

class Saved: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var savedTableView: UITableView!
    @IBOutlet weak var numSavedField: UILabel!
    
    var num: Int = 0
    
    // function called upon loading of screen
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser;
        let uid = user?.uid
        globalVariables.savedResults = []
        downloadSavedDishes(user: uid!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // function that downloads the saved dishes from database
    func downloadSavedDishes(user: String) {
        let databaseRef = Database.database().reference().child("Users").child("\(user)").child("SavedDishes")
        
        databaseRef.observe(.childAdded, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String, Any>
            
            let dishName = snapshotValue["Name"] as! String
            let dishServings = snapshotValue["Number of Servings"] as! Int
            let dishRecipeURL = snapshotValue["Recipe URL"] as! String
            let dishImageURL = snapshotValue["Image URL"] as! String
            let dishCalories = snapshotValue["Calories"] as! Int
            let dishIngredients = snapshotValue["Ingredients"] as! [String]
            let dishDietPreferences = snapshotValue["Diet Preferences"] as! [String]
            let dishDietRestrictions = snapshotValue["Diet Restrictions"] as! [String]
            
            let savedDish = Dish(nameResult: dishName, servingsResult: dishServings, recipeURLResult: dishRecipeURL, imageURLResult: dishImageURL, caloriesResult: dishCalories, ingredientResults: dishIngredients, dietPreferenceResult: dishDietPreferences, dietRestrictionResult: dishDietRestrictions)
            
            globalVariables.savedResults.append(savedDish)
            
            self.numSavedField.text = String(describing: globalVariables.savedResults.count)
            
            self.savedTableView.reloadData()
            
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalVariables.savedResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        num = globalVariables.savedResults.count - 1
        
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let cellText = globalVariables.savedResults[num - indexPath.row].getName()
        cell.textLabel?.text = cellText
        
        let ingredientsArray = globalVariables.savedResults[num - indexPath.row].getIngredients()
        var cellSubtitle: String = ""
        for ingredient in ingredientsArray {
            cellSubtitle += ingredient
            cellSubtitle += "; "
        }
        cellSubtitle = String(cellSubtitle.dropLast())
        cellSubtitle = String(cellSubtitle.dropLast())
        cell.detailTextLabel?.text = cellSubtitle
        
        let cellURL = globalVariables.savedResults[num - indexPath.row].getImageURL()
        let url = URL(string: cellURL)
        cell.imageView?.kf.indicatorType = .activity
        cell.imageView?.kf.setImage(with: url, completionHandler: {
            (image, error, cacheType, imageUrl) in
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        globalVariables.selectedDish = num - indexPath.row
        performSegue(withIdentifier: "goToSingle", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

}
