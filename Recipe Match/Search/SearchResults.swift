//
//  SearchResults.swift
//  Recipe Match
//
//  Created by Karan Jaisingh on 7/27/18.
//  Copyright © 2018 KaranJaisinghOrg. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import SVProgressHUD

class SearchResults: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var resultsTableView: UITableView!
    
    // function called upon loading of screen
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        resultsTableView.backgroundColor = UIColor.clear
        resultsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none

        // URL base
        var httpURL = "https://api.edamam.com/search?q="
        // adding high priority ingredients
        for i in globalVariables.highPriority {
            var ingredient = i
            ingredient = ingredient.lowercased()
            ingredient = ingredient.replacingOccurrences(of: " ", with: "")
            httpURL += ingredient
            httpURL += ","
        }
        // adding low priority ingredients
        for i in globalVariables.lowPriority {
            var ingredient = i
            ingredient = ingredient.lowercased()
            ingredient = ingredient.replacingOccurrences(of: " ", with: "")
            httpURL += ingredient
            httpURL += ","
        }
        // removing the final character (a ',')
        httpURL = String(httpURL.dropLast())
        // adding information including the app key and number of results returned
        httpURL += "&app_id=a11c0d88&app_key=6d0269d7b6b72c3f4fa8f04b39f364de&from=0&to=10"
        
        let userPreference = (globalVariables.userDetails?.getDietPreference())!
        // add diet preference to recipe search, if applicable
        if(userPreference != "None" && userPreference != "none" && userPreference != "") {
            httpURL += "&diet="
            var diet = (globalVariables.userDetails?.getDietPreference())!
            diet = diet.lowercased()
            diet = diet.replacingOccurrences(of: " ", with: "-")
            httpURL += diet
        }
        
        let userRestriction = (globalVariables.userDetails?.getDietRestriction())!
        // add diet restriction to recipe search, if applicable
        if(userRestriction != "None" && userRestriction != "none" && userRestriction != "") {
            httpURL += "&health="
            var health = (globalVariables.userDetails?.getDietRestriction())!
            health = health.lowercased()
            health = health.replacingOccurrences(of: " ", with: "-")
            httpURL += health
        }
        
        // execute URL get request
        getRecipes(url: httpURL)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // function that gets recipes from recipe database corresponding to API URL details
    func getRecipes(url: String) {
        
        print(url)
        
        // request data from server through API
        Alamofire.request(url).responseJSON { (response) in
            // check if the request was successful
            if response.result.isSuccess {
                // parse retrieved data into JSON format
                let recipeJSON: JSON = JSON(response.result.value!)
                self.updateRecipeData(json: recipeJSON)
                // check if matches are found
                if(globalVariables.dishesResults.count > 0) {
                    // filter results if matches found
                    self.filterDishes()
                    self.resultsTableView.reloadData()
                } else {
                    // notify user if no matches were found
                    self.createAlert(title: "Error getting results", message: "We could not find any recipes matching your given filters. Please try again with a different set of ingrediets, preferences or restrictions.")
                }
                SVProgressHUD.dismiss()
            } else {
                // notify user if request was unsuccessful
                self.createAlert(title: "Error getting results", message: "We could not find any recipes matching your given filters. Please try again with a different set of ingrediets, preferences or restrictions.")
                SVProgressHUD.dismiss()
            }
        }
        
    }
    
    // setting number of rows in section to number of recipes retrieved
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalVariables.dishesResults.count
    }
    
    // setting custom height of each table view cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    // modifying data in each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let cellText = globalVariables.dishesResults[indexPath.row].getName()
        cell.textLabel?.text = cellText
        
        // adding and formatting ingredients to the cell subtitle
        let ingredientsArray = globalVariables.dishesResults[indexPath.row].getIngredients()
        var cellSubtitle: String = ""
        for ingredient in ingredientsArray {
            cellSubtitle += ingredient
            cellSubtitle += "; "
        }
        cellSubtitle = String(cellSubtitle.dropLast())
        cellSubtitle = String(cellSubtitle.dropLast())
        cell.detailTextLabel?.text = cellSubtitle
        
        // get image URL from object using accessor methods
        let cellURL = globalVariables.dishesResults[indexPath.row].getImageURL()
        // parse to URL data type
        let url = URL(string: cellURL)
        // use Kingfisher to download image, setting the cell image to it
        cell.imageView?.kf.indicatorType = .activity
        cell.imageView?.kf.setImage(with: url, completionHandler: {
            (image, error, cacheType, imageUrl) in
            cell.imageView?.image = self.squareImage(image: image!, size: 80.0)
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        })
        
        // set cell properties
        cell.backgroundColor = .clear
        cell.imageView?.layer.cornerRadius = 10
        cell.layer.cornerRadius = 15
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.green.cgColor
        cell.frame = cell.frame.insetBy(dx: 10, dy: 10)
        
        return cell
        
    }
    
    // function called when a recipe is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        globalVariables.selectedDish = indexPath.row
        performSegue(withIdentifier: "goToSingle", sender: self)
    }
    
    // filter recipes from JSON retrieved
    func updateRecipeData(json: JSON) {
                
        for i in 0...9 {
    
            let yieldResult = String(describing: json["hits"][i]["recipe"]["yield"])
            let yieldResultInt = Int(yieldResult)!
            
            let labelResult = String(describing: json["hits"][i]["recipe"]["label"])
            
            let caloriesResult = String(describing: json["hits"][i]["recipe"]["calories"])
            let caloriesResultInt = Int(Double(caloriesResult)!)
            
            let imageURLResult = String(describing: json["hits"][i]["recipe"]["image"])
            
            let recipeURLResult = String(describing: json["hits"][i]["recipe"]["url"])
            
            var ingredientsResult = [String]()
            for j in 0...(json["hits"][i]["recipe"]["ingredientLines"].count - 1) {
                ingredientsResult.append(String(describing: json["hits"][i]["recipe"]["ingredientLines"][j]))
            }
            
            var dietPreferencesResult = [String]()
            if(json["hits"][i]["recipe"]["dietLabels"].count > 0) {
                for j in 0...(json["hits"][i]["recipe"]["dietLabels"].count - 1) {
                    dietPreferencesResult.append(String(describing: json["hits"][i]["recipe"]["dietLabels"][j]))
                }
            } else {
                dietPreferencesResult.append("None")
            }
            
            var dietRestrictionResult = [String]()
            if(json["hits"][i]["recipe"]["healthLabels"].count > 0) {
                for j in 0...(json["hits"][i]["recipe"]["healthLabels"].count - 1) {
                    dietRestrictionResult.append(String(describing: json["hits"][i]["recipe"]["healthLabels"][j]))
                }
            } else {
                dietRestrictionResult.append("None")
            }
            
            let dish = Dish(nameResult: labelResult, servingsResult: yieldResultInt, recipeURLResult: recipeURLResult, imageURLResult: imageURLResult, caloriesResult: caloriesResultInt, ingredientResults: ingredientsResult, dietPreferenceResult: dietPreferencesResult, dietRestrictionResult: dietRestrictionResult)
            
            globalVariables.dishesResults.append(dish)
            
        }
    }
    
    // algorithm that filters dishes based on their relevance
    func filterDishes() {
        
        var scores: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        var sortedResult = [Dish]()
        
        // repeating for each dish retrieved from database
        for i in 0...(globalVariables.dishesResults.count - 1) {
            // initializing score to zero
            var score: Int = 0
            if(globalVariables.highPriority.count > 0) {
                // repeating for each element in the highPriority[] ingredients array
                for j in 0...(globalVariables.highPriority.count - 1) {
                    // repeating for each element in the recipe
                    for k in 0...(globalVariables.dishesResults[i].getIngredients().count - 1) {
                        // check for match
                        if(globalVariables.highPriority[j].lowercased() == globalVariables.dishesResults[i].ingredients[k].lowercased()) {
                            // adding a score of 10 if the ingredient is found
                            score += 10
                        } else {
                            // subtracting a score of 2 if the ingredient is not found
                            score -= 2
                        }
                    }
                }
            }
            if(globalVariables.lowPriority.count > 0) {
                // repeating for each element in the lowPriority[] ingredients array
                for j in 0...(globalVariables.lowPriority.count - 1) {
                    // repeating for each element in the recipe
                    for k in 0...(globalVariables.dishesResults[i].getIngredients().count - 1) {
                        // check for match
                        if(globalVariables.lowPriority[j].lowercased() == globalVariables.dishesResults[i].ingredients[k].lowercased()) {
                            // adding a score of 5 if the ingredient is found
                            score += 5
                        } else {
                            // subtracting a score of 1 if the ingredient is not found
                            score -= 1
                        }
                    }
                }
            }
            scores[i] = score
        }
        
        // reorganize dishes based on their relevance scores
        for i in 0...(globalVariables.dishesResults.count - 1) {
            var highScore: Int = scores[0]
            var highPos: Int = 0
            for i in 0...(globalVariables.dishesResults.count - 1) {
                if(scores[i] > highScore) {
                    highScore = scores[i]
                    highPos = i
                }
            }
            sortedResult.append(globalVariables.dishesResults[highPos])
            scores[highPos] = -1000
        }
        
        globalVariables.dishesResults = sortedResult
        
    }
    
    // function that creates an alert given parameters
    func createAlert(title: String, message: String) {
        let errormsg = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        errormsg.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler:  { (action) in
            errormsg.dismiss(animated: true, completion: nil)
        }))
        self.present(errormsg, animated: true, completion: nil)
    }
    
    // function that squares image
    func squareImage(image: UIImage, size: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: size, height: size))
        image.draw(in: CGRect(x: 0, y: 0, width: size, height: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}



