//
//  TaskCategoryViewModel.swift
//  ToDoApp
//
//  Created by Jack Adams on 24/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import Foundation
import UIKit



class CategoryViewModel {
    
    private var category: Category!
    private var categoryModelController: CategoryModelController!
    
    
    var name: String
    var foregroundColour: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var backgroundColour: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var borderColour: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var textColour: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    var isDisplayingOnMenu: Bool {
        didSet {
            setUIColors()
        }
    }
    var isCurrentlySelectedForTask: Bool = false {
        didSet {
            setUIColors()
        }
    }
    
    var taskFilter: (Todo) -> Bool {
        return { todo in
            return todo.categoryIDs.contains(self.category.id)
        }
    }
    
    var emoji: String
    
    init(category: Category, categoryModelController: CategoryModelController, onMenu: Bool = false) {
        self.category = category
        self.categoryModelController = categoryModelController
        self.name = category.name
        self.emoji = category.emoji
        self.isDisplayingOnMenu = onMenu
        setUIColors()
        
        
    }
    
    func delete() {
        categoryModelController.deleteCategory(withID: category.id)
    }
    
    
    private func setUIColors() {
        let rawColour = rawUIColor()
        foregroundColour = rawColour
        
        
        
        if isDisplayingOnMenu {
            backgroundColour = rawColour.withAlphaComponent(0.5)
        } else if isCurrentlySelectedForTask {
            backgroundColour = rawColour.withAlphaComponent(0.8)
            borderColour = backgroundColour
            textColour = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            backgroundColour = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            borderColour = foregroundColour
            textColour = foregroundColour
        }
        
    }
    
    private func rawUIColor() -> UIColor {
        if let categoryColourName = CategoryColours(rawValue: category.colour) {
            if let categoryColour = Config.categoryColours.first(where: { $0.name == categoryColourName}) {
                return categoryColour.colour
            }
        }
        
        return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    
    
}
