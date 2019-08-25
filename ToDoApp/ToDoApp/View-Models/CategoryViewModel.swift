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
    
    var isDisplayingOnTask = false
    
    var name: String
    var foregroundColour: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var backgroundColour: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    var isDisplayingOnMenu: Bool {
        didSet {
            setUIColors()
        }
    }
    var isCurrentlySelectedForTask: Bool? {
        didSet {
            setUIColors()
        }
    }
    
    var taskFilter: (Todo) -> Bool {
        return { (todo) -> Bool in
            return todo.categoryIDs.contains(self.category.id)
        }
    }
    
    var emoji: String
    
    init(category: Category, onMenu: Bool = false) {
        self.category = category
        self.name = category.name
        self.emoji = category.emoji
        self.isDisplayingOnMenu = onMenu
        setUIColors()
        
        
    }
    
    
    private func setUIColors() {
        let rawColour = rawUIColor()
        foregroundColour = rawColour
        
        var alpha: CGFloat
        
        if isDisplayingOnMenu {
            alpha = 0.5
        } else if let selected = isCurrentlySelectedForTask, !selected {
            alpha = 0.2
        } else {
            alpha = 0.8
        }
        
        backgroundColour = rawColour.withAlphaComponent(alpha)
        
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
