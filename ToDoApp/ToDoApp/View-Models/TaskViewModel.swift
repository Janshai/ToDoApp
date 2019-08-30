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
    private var task: Todo {
        didSet {
            self.title = task.title
            setCategoryFields()
        }
    }
    
    var title: String!
    var primaryCategory: CategoryViewModel?
    var categories = [CategoryViewModel]()
    var isDisplayingOnMenu: Bool
    
    init(task: Todo, onMenu: Bool = false) {
        self.task = task
        self.title = task.title
        self.isDisplayingOnMenu = onMenu
        setCategoryFields()
    }
    
    private func setCategoryFields() {
        self.categories = fetchCategoryViewModels()
        self.primaryCategory = categories.count >= 1 ? categories[0] : nil
    }
    
    private func fetchCategoryViewModels() -> [CategoryViewModel] {
        return task.categoryIDs.compactMap({ CategoryModelController.shared.getCategoryViewModel(withID: $0, forDisplayingOnMenu: self.isDisplayingOnMenu)})
    
    }
    
    func edit(withNewValues values: [TodoFields: Encodable], andOnCompletion completion: @escaping (_ result: Result<TaskViewModel, Error>) -> Void) {
        ToDoModelController.shared.editTodo(withIdentifier: task.id, andNewValues: values) { result in
            switch result {
            case .success(let task):
                self.task = task
                completion(.success(self))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func delete() {
        ToDoModelController.shared.deleteTodo(withIdentifier: task.id) { _ in }
    }
    
    class func getAllTaskViewModels(applyingFilter filter: ((Todo) -> Bool)? = nil, forDisplayingOnMenu menu: Bool = false) -> [TaskViewModel] {
        let tasks = ToDoModelController.shared.getAllTasks(applyingFilter: filter)
        return tasks.map(){ TaskViewModel(task: $0, onMenu: menu) }
    }
    
    class func addTask(withValues values: [TodoFields: Encodable], onCompletion completion: @escaping (Bool) -> Void) {
        
        
        
        ToDoModelController.shared.addTodo(withValues: values){ result in
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
