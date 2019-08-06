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
    
    func addTodo(withTitle title: String) -> Result<String, Error> {
        
        let values: [TodoFields: Encodable] = [TodoFields.title: title]
        var newTodo: Todo?
        let group = DispatchGroup()
        group.enter()
        todoDataProvider.addTodo(withValues: values) { result in
            print("here")
            switch result {
            case .success(let todo): newTodo = todo
            case .failure(let error): print(error)
            }
            group.leave()
        }
        group.wait()
        
        if let todo = newTodo {
            todos += [todo]
            return .success(todo.id)
        } else {
            return .failure(TimeOutError())
        }
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

struct TimeOutError: Error {
    
}
