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
    var selectedCategory:Category?{
        didSet{
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedCategory!.name
        loadItems()
    }
    override func viewWillAppear(_ animated: Bool) {
        if let categoryColor = UIColor(hexString: (selectedCategory?.color)!){
            let contrastColor = UIColor.init(contrastingBlackOrWhiteColorOn: categoryColor, isFlat: true)
            editNavBar(bgColor: categoryColor, navigationItem, navigationController)
            searchBar.searchTextField.textColor = contrastColor
            searchBar.barTintColor = categoryColor
        }
    }

//MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { alert in
            let newItem = Item()
            newItem.title = textField.text!
            
            do{
                try self.realm.write({
                    self.selectedCategory?.items.append(newItem)
                    self.loadItems()
                })
            }catch{
                print("Error while saving item, \(error)")
            }
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
        if let item = itemsArray?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.backgroundColor = UIColor.systemBlue
            if let bgColor = UIColor(hexString: (selectedCategory?.color)!){
                let bgContrast = UIColor.init(contrastingBlackOrWhiteColorOn: bgColor, isFlat: true)
                cell.textLabel?.textColor = bgContrast
                cell.backgroundColor = bgColor
            }
            cell.accessoryType = item.done ? .checkmark:.none
        }
        return cell
    }
    
//MARK: - TableViewDelegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do{
            try realm.write {
                itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
                tableView.reloadData()
            }
        }catch{
            print("Error \(error)")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//MARK: - Data Manipulation Methods
    
    func loadItems(){
        itemsArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
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

//MARK: - SearchBarDelegate Methods
extension TodoListTableViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            searchBar.endEditing(true)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemsArray = itemsArray?.filter("title CONTAINS[cd] %@", searchBar.searchTextField.text!).sorted(byKeyPath: "title", ascending: true)
        searchBar.resignFirstResponder()
//        DispatchQueue.main.async {
//            searchBar.resignFirstResponder()
//        }
        tableView.reloadData()
    }
}
