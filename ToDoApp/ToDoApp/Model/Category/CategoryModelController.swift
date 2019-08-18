//
//  CategoryModelController.swift
//  ToDoApp
//
//  Created by Jack Adams on 18/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import Foundation

class CategoryModelController {
    private var categories: [Category]
//    private let categoryDataProvider: CategoryDataProvider
    public var numberOfCategories: Int {
        return categories.count
    }
    
//    init (categoryDataProvider: CategoryDataProvider? = nil) {
//        self.categoryDataProvider = categoryDataProvider ?? DefaultCategoryDataProvider()
//        self.categories = categoryDataProvider.fetchCategories()
//    }
    
    init () {
        self.categories = [Category(name: "Productivity"),
                           Category(name: "School")]
    }
    
    public func getCategory(withID id: String) -> Category? {
        if let index = categories.firstIndex(where: { $0.id == id }) {
            return categories[index]
        } else {
            return nil
        }
    }
    
    public func getCategory(atIndex index: Int) -> Category {
        return categories[index]
    }
    
}
