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
    
    private var category: Category! {
        didSet {
            reset()
        }
    }
    
    
    var name: String
    private(set) var foregroundColour: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    private(set) var backgroundColour: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    private(set) var borderColour: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    private(set) var textColour: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var colour: CategoryColours {
        didSet {
            setUIColors()
        }
    }
    
    var id: String {
        return category.id
    }
    
    
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
    
    var emoji: String?
    
    init(category: Category, onMenu: Bool = false) {
        self.category = category
        self.name = category.name
        self.emoji = category.emoji
        self.colour = CategoryColours(rawValue: category.colour)!
        self.isDisplayingOnMenu = onMenu
        setUIColors()
        
        
    }
    
    func delete() {
        CategoryModelController.shared.deleteCategory(withID: category.id)
    }
    
    func updateModel(onCompletion completion: @escaping (Bool) -> Void) {
        CategoryModelController.shared.editCategory(withID: category.id, andNewValues: collectNewValues()) { result in
            switch result {
            case .success(let category):
                self.category = category
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    private func collectNewValues() -> [CategoryFields:Encodable] {
        var dict = [CategoryFields:Encodable]()
        if self.name != category.name {
            dict[.name] = self.name
        }
        
        if self.emoji != category.emoji {
            dict[.emoji] = self.emoji
        }
        
        if self.colour.rawValue != category.colour {
            dict[.colour] = self.colour.rawValue
        }
        return dict
    }
    
    func reset() {
        self.name = category.name
        self.colour = CategoryColours(rawValue: category.colour)!
        self.emoji = category.emoji
    }
    
    private func setUIColors() {
        let rawColour = rawUIColor()
        foregroundColour = rawColour
        
        
        
        if isDisplayingOnMenu {
            backgroundColour = rawColour != #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) ? rawColour.withAlphaComponent(0.3) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else if isCurrentlySelectedForTask {
            backgroundColour = rawColour != #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) ? rawColour.withAlphaComponent(0.5) : #colorLiteral(red: 0.1976919416, green: 0.1976919416, blue: 0.1976919416, alpha: 1)
            borderColour = backgroundColour
            textColour = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            backgroundColour = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            borderColour = foregroundColour != #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) ? foregroundColour : #colorLiteral(red: 0.1976919416, green: 0.1976919416, blue: 0.1976919416, alpha: 1)
            textColour = borderColour
        }
        
    }
    
    private func rawUIColor() -> UIColor {
        
        if let categoryColour = Config.categoryColours.first(where: { $0.name == colour}) {
            return categoryColour.colour
        }
        
        
        return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    
    
    class func addCategory(withValues values: [CategoryFields:Encodable], onCompletion completion: @escaping (Bool) -> Void) {
        
        CategoryModelController.shared.addCategory(withValues: values) { result in
            switch result {
            case .success(_): completion(true)
            case .failure(_): completion(false)
            }
        }
        
    }
    
    
    
}
