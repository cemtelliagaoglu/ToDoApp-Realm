//
//  SwipeTableViewController.swift
//  ToDoApp-Realm
//
//  Created by admin on 27.06.2022.
//

import Foundation
import SwipeCellKit


class SwipeTableViewCellController: UITableViewController,SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.delete(indexPath)
            
        }
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func delete(_ indexPath: IndexPath){
        
    }
    //MARK: - NavigationBar Setup
    func editNavBar(bgColor: UIColor, _ navigationItem:UINavigationItem, _ navigationController: UINavigationController?){
        let contrastColor = UIColor.init(contrastingBlackOrWhiteColorOn:bgColor , isFlat: true)
        let navBarAppearance = UINavigationBarAppearance()
        let navBar = navigationController?.navigationBar
        
       navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: contrastColor, .font: UIFont(name: "Verdana", size: 25)!]
       navBarAppearance.backgroundColor = bgColor

       navigationItem.rightBarButtonItem?.tintColor = contrastColor
       navigationItem.backBarButtonItem?.tintColor = contrastColor
       navBar?.tintColor = contrastColor

       navBar?.scrollEdgeAppearance = navBarAppearance
    }
}
