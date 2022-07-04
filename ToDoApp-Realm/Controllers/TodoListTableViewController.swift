//
//  TodoListTableViewController.swift
//  ToDoApp-Realm
//
//  Created by admin on 28.06.2022.
//

import UIKit
import RealmSwift

class TodoListTableViewController: SwipeTableViewCellController {

    let realm = try! Realm()
    var itemsArray: Results<Item>!
    var selectedCategory:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
//MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { alert in
            let newItem = Item()
            newItem.title = textField.text!
            self.save(newItem)
        }
        alert.addAction(action)
        alert.addTextField { field in
            textField = field
            textField.placeholder = "Add New Item"
        }
        present(alert, animated: true, completion: nil)
    }
    

//MARK: - TableViewDataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = itemsArray[indexPath.row].title
        return cell
    }
    
    
    
//MARK: - Data Manipulation Methods
    func save(_ newItem: Item){
        do{
            try realm.write({
                realm.add(newItem)
            })
        }catch{
            print("Error while saving item, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(){
        itemsArray = realm.objects(Item.self)
        tableView.reloadData()
    }
    override func delete(_ indexPath: IndexPath) {
        if let item = itemsArray?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(item)
                }
            }
            catch{
                print("Error while deleting, \(error)")
            }
        }
    }

}
