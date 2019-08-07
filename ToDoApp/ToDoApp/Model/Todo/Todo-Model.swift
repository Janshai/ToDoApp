//
//  Todo-Model.swift
//  ToDoApp
//
//  Created by Jack Adams on 29/06/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import Foundation


class ToDoModelController {
    
    private var todoDataProvider: TodoDataProvider
    private var todos: [Todo] = []
    var numberOfTodos: Int {
        return todos.count
    }
    
    //TODO: make init optional and then handle this at the front end by hiding the tableview and displaying try again later message
    
    init(todoDataProvider: TodoDataProvider? = nil, group: DispatchGroup) {
        self.todoDataProvider = todoDataProvider ?? NetworkTodoDataProvider()
        group.enter()
        self.todoDataProvider.fetchTodos() { result in
            switch result {
            case .success(let todos): self.todos = todos
            case .failure(let error): print(error.localizedDescription)
            }
            group.leave()
        }

    }
    
    func getTodo(atIndex index: Int) -> Todo {
        return todos[index]
    }
    
    func addTodo(withTitle title: String, andOnCompletion completion: @escaping (_ result: Result<Todo, Error>) -> Void){
        
        let values: [TodoFields: Encodable] = [TodoFields.title: title]
        
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
    func editTodo(withIdentifier id: String, andNewValues values: [TodoFields: Encodable], andOnCompletion completion: @escaping (_ result: Result<String, SyncError>) -> Void) {
        //TODO: Use the Completion
        let todo = todos.first(where: {$0.id == id})
        if let newTitle = values[.title] as? String {
            todo?.title = newTitle
        }
        
        todoDataProvider.updateTodo(withID: id, withNewValues: values)
        
        
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
