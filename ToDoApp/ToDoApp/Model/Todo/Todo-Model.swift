//
//  Todo-Model.swift
//  ToDoApp
//
//  Created by Jack Adams on 29/06/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import Foundation


class ToDoModelController {
    private(set) static var shared = ToDoModelController()
    
    private var todoDataProvider: TodoDataProvider
    private var todos: [Todo] = []
    
    //TODO: make init optional and then handle this at the front end by hiding the tableview and displaying try again later message
    
    init(todoDataProvider: TodoDataProvider? = nil) {
        self.todoDataProvider = todoDataProvider ?? NetworkTodoDataProvider()
        
        
    }
    
    func fetchTasks(inDispatchGroup group: DispatchGroup) {
        group.enter()
        self.todoDataProvider.fetchTodos() { result in
            switch result {
            case .success(let todos): self.todos = todos
            case .failure(let error): print(error.localizedDescription)
            }
            group.leave()
        }
    }
    
    func numberOfTodos(applyingFilter filter: ((Todo) -> Bool)? = nil) -> Int {
        if let setFilter = filter {
            return todos.filter(setFilter).count
        } else {
            return todos.count
        }
    }
    
    func getTodo(atIndex index: Int, applyingFilter filter: ((Todo) -> Bool)? = nil) -> Todo {
        if let setFilter = filter {
            let filteredTodos = todos.filter(setFilter)
            return filteredTodos[index]
        } else {
            return todos[index]
        }
        
    }
    
    func addTodo(withValues values: [TodoFields: Encodable], andOnCompletion completion: @escaping (_ result: Result<Todo, Error>) -> Void){
        
        todoDataProvider.addTodo(withValues: values) { result in
            switch result {
            case .success(let todo):
                self.todos += [todo]
                completion(.success(todo))
            case .failure(let error):
                print(error)
                let userError = SyncError(method: .addTodo)
                completion(.failure(userError))
            }
        }
    }
    
    /// Deletes the Todo with the given identifier both locally and remotely.
    /// The function pre-emptively deletes the todo locally so the UI can be reloaded immediately if you wish. Then asynchronously deletes the remote version.
    /// - Parameter withIdentifier: The String Identifier of the Todo you wish to delete
    /// - Parameter andOnCompletion: Completion block to be called once the remote delete has been executed. A Result is passed into the completion block that contains the String ID of the deleted Todo if the delete is successful, or a SyncError struct with details of the failure.
    func deleteTodo(withIdentifier id: String, andOnCompletion completion: @escaping (_ result: Result<String, SyncError>) -> Void) {
        //TODO: If the remote deletion is unsuccessful reinstate the deleted ToDo
        //TODO: Use Completion Block
        todoDataProvider.deleteTodo(withID: id)
        todos.removeAll(where: {$0.id == id})
    }
    
    /// Updates the Todo with the given identifier both locally and remotely.
    /// The function pre-emptively updates the todo locally so the UI can be reloaded immediately if you wish. Then asynchronously updates the remote version.
    /// - Parameter withIdentifier: The String Identifier of the Todo you wish to update
    /// - Parameter andOnCompletion: Completion block to be called once the remote update has been executed. A Result is passed into the completion block that contains the String ID of the updated Todo if the update is successful, or a SyncError struct with details of the failure .
    func editTodo(withIdentifier id: String, andNewValues values: [TodoFields: Encodable], andOnCompletion completion: @escaping (_ result: Result<Todo, SyncError>) -> Void) {
        
        func createEditSyncError() -> SyncError {
            let index = self.todos.firstIndex(where: {$0.id == id})
            return SyncError(index: index, method: .updateTodo)
        }
        
        todoDataProvider.updateTodo(withID: id, withNewValues: values) { result in
            switch result {
            case .success(let todo):
                if let editedTodo = self.todos.first(where: {$0.id == todo.id}) {
                    editedTodo.title = todo.title
                    editedTodo.categoryIDs = todo.categoryIDs
                    completion(.success(editedTodo))
                } else {
                    completion(.failure(createEditSyncError()))
                }
                
            case .failure(_):
                completion(.failure(createEditSyncError()))
            }
            
            
        }
        
        
    }
    
    func getAllTasks(applyingFilter filter: ((Todo) -> Bool)? = nil) -> [Todo] {
        var desiredTasks: [Todo]
        if let setFilter = filter {
            desiredTasks = todos.filter(setFilter)
        } else {
            desiredTasks = todos
        }
        
        return desiredTasks
    }
    
    func getAllTaskViewModels(applyingFilter filter: ((Todo) -> Bool)? = nil, forDisplayingOnMenu menu: Bool = false) -> [TaskViewModel] {
        var desiredTasks: [Todo]
        if let setFilter = filter {
            desiredTasks = todos.filter(setFilter)
        } else {
            desiredTasks = todos
        }
        
        return desiredTasks.map(){ TaskViewModel(task: $0, onMenu: menu) }
    }
}

struct SyncError: Error {
    var index: Int?
    var method: SyncErrorAction
    
    init(index: Int? = nil, method: SyncErrorAction) {
        self.index = index
        self.method = method
    }
    
    enum SyncErrorAction {
        case addTodo
        case deleteTodo
        case updateTodo
    }
    
}
