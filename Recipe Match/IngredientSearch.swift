
import UIKit

class IngredientSearch: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var ingredients = ["Chicken", "Beef", "Turkey", "Pork", "Sausage", "Salmon", "Tuna", "Steak", "Lamb", "Ham", "Duck", "Crab", "Shrimp", "Prawns", "Lobster", "Trout", "Tilapia",  "Oil", "Rice", "Noodle", "Peanut", "Pepper", "Ginger", "Garlic", "Tomato", "Onion", "Beans", "Potato", "Broccoli", "Carrots", "Lettuce", "Mushroom", "Beetroot", "Eggplant", "Avacado", "Asparagus", "Pumpkin", "Radish", "Spinach", "Squash", "Soybean", "Couscous", "Milk", "Cheese", "Herb", "Bread", "Vinegar", "Eggs", "Butter", "Pepper", "Coconut", "Lemon", "Chilli", "Cinnamon", "Flour", "Paprika",  "Chocolate", "Cream", "Sugar", "Candy", "Honey", "Yoghurt", "Syrup", "Wine", "Beer"]
    
    // array holding ingredients inputted thus far
    var filteredIngredients = [String]()
    
    // array that checks whether the search bar is searching
    var isSearching = false
    
    // function called upon loading of screen
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // reformat ingredients array
        for i in globalVariables.highPriority {
            if(ingredients.contains(i)) {
                ingredients = ingredients.filter {$0 != i}
            }
        }
        
        // reformat ingredients array
        for i in globalVariables.lowPriority {
            if(ingredients.contains(i)) {
                ingredients = ingredients.filter {$0 != i}
            }
        }
        
        // set delegates and data sources
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // set number of sections in table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // set number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredIngredients.count
        } else {
            return ingredients.count
        }
    }
    
    // create cell for each separate ingredient
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellText: String
        
        if isSearching {
            cellText = filteredIngredients[indexPath.row]
        } else {
            cellText = ingredients[indexPath.row]
        }
        
        let cellIdentifier = "TableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = cellText
        
        return cell
    }
    
    // add ingredient to ingredients list if tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(isSearching) {
            if(globalVariables.priorityChoice == 1) {
                globalVariables.highPriority.append(filteredIngredients[indexPath.row])
            } else {
                globalVariables.lowPriority.append(filteredIngredients[indexPath.row])
            }
            
        } else {
            if(globalVariables.priorityChoice == 1) {
                globalVariables.highPriority.append(ingredients[indexPath.row])
            } else {
                globalVariables.lowPriority.append(ingredients[indexPath.row])
            }
        }
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    // function that checks whether text in search bar changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredIngredients = ingredients.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        isSearching = true
        tableView.reloadData()
    }
    
    // function called when the cancel button is clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        tableView.reloadData()
    }

}
