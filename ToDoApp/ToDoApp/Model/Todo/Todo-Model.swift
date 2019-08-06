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
    
    var numberOfTodos: Int {
        return todos.count
    }
    
    private func getAllTodos() -> [Todo] {
        
        return todos
    }
    
    
    func getTodo(atIndex index: Int) -> Todo {
        return todos[index]
    }
    
    func addTodo(withTitle title: String) {
        let values: [TodoFields: Any] = [TodoFields.title: title]
        let newTodo = todoDataProvider.addTodo(withValues: values)
        todos += [newTodo]
    }
    
    func deleteTodo(withIdentifier id: String) {
        todoDataProvider.deleteTodo(withID: id)
        todos.removeAll(where: {$0.id == id})
    }
    
    func editTodo(withIdentifier id: String, toNowEqual newTodo: Todo) {
        //TODO: Make use data provider
        let todo = todos.first(where: {$0.id == id})
        todo?.title = newTodo.title
    }
}
