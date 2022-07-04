//
//  DataModel.swift
//  ToDoApp-Realm
//
//  Created by admin on 27.06.2022.
//

import Foundation
import RealmSwift

class Category:Object{
    @objc dynamic var name: String = ""
    let items = List<Item>()
}

class Item:Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
