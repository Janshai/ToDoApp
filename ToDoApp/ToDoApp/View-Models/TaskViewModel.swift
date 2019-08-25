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
    var taskModel: ToDoModelController
    
    var title: String
    var primaryCategory: CategoryViewModel?
    var categories = [CategoryViewModel]()
    var isDisplayingOnMenu: Bool
    
    init(task: Todo, taskModel: ToDoModelController, categoryModel: CategoryModelController?, onMenu: Bool = false) {
        self.task = task
        self.title = task.title
        self.isDisplayingOnMenu = onMenu
        self.taskModel = taskModel
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
        taskModel.deleteTodo(withIdentifier: task.id) { _ in }
    }
}
