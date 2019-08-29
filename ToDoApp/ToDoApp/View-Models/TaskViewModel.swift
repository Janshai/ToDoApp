//
//  TaskViewModel.swift
//  ToDoApp
//
//  Created by Jack Adams on 25/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import Foundation
import UIKit

class TaskViewModel {
    private var task: Todo
    var categoryModel: CategoryModelController? {
        didSet {
            setCategoryFields()
        }
    }
    
    var title: String
    var primaryCategory: CategoryViewModel?
    var categories = [CategoryViewModel]()
    var isDisplayingOnMenu: Bool
    
    init(task: Todo, categoryModel: CategoryModelController?, onMenu: Bool = false) {
        self.task = task
        self.title = task.title
        self.isDisplayingOnMenu = onMenu
        self.categoryModel = categoryModel
        setCategoryFields()
    }
    
    private func setCategoryFields() {
        self.categories = fetchCategoryViewModels()
        self.primaryCategory = categories.count >= 1 ? categories[0] : nil
    }
    
    private func fetchCategoryViewModels() -> [CategoryViewModel] {
        return task.categoryIDs.compactMap({ self.categoryModel?.getCategoryViewModel(withID: $0, forDisplayingOnMenu: self.isDisplayingOnMenu)})
    
    }
    
    func delete() {
        ToDoModelController.shared.deleteTodo(withIdentifier: task.id) { _ in }
    }
    
    class func getAllTaskViewModels(applyingFilter filter: ((Todo) -> Bool)? = nil, forDisplayingOnMenu menu: Bool = false) -> [TaskViewModel] {
        let tasks = ToDoModelController.shared.getAllTasks(applyingFilter: filter)
        return tasks.map(){ TaskViewModel(task: $0, categoryModel: nil, onMenu: menu) }
    }
    
    class func addTask(withTitle title: String, completion: @escaping (Bool) -> Void) {
        ToDoModelController.shared.addTodo(withTitle: title){ result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    completion(true)
                }
            case .failure(_):
                print("Failure caught in VC")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
        
    }
    
}
