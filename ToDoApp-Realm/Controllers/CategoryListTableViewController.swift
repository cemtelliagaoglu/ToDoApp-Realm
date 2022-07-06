//
//  ViewController.swift
//  ToDoApp-Realm
//
//  Created by admin on 27.06.2022.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryListViewController: SwipeTableViewCellController{

    let realm = try! Realm()
    var categories: Results<Category>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        editNavBar(bgColor: .white, navigationItem, navigationController)
    }
    
    //MARK: - Adding New Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { alert in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            self.save(newCategory)
        }
        alert.addAction(action)
        alert.addTextField { field in
            textField = field
            textField.placeholder = "Add New Category"
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        
        if let bgColor = UIColor(hexString: (categories[indexPath.row].color)!){
            let bgContrast = UIColor.init(contrastingBlackOrWhiteColorOn: bgColor, isFlat: true)
            cell.textLabel?.textColor = bgContrast
            cell.backgroundColor = bgColor
        }
        
        return cell
    }
    
    //MARK: - TableViewDelegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow{
        let destinationVC = segue.destination as! TodoListTableViewController
        destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func save(_ category: Category){
        do{
            try realm.write({
                realm.add(category)
            })
        }catch{
            print("Error while saving categories, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        categories = realm.objects(Category.self).sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
    override func delete(_ indexPath: IndexPath) {
        if let category = categories?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(category)
                }
            }
            catch{
                print("Error while deleting, \(error)")
            }
        }
    }
}

