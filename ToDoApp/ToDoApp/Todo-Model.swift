//
//  Todo-Model.swift
//  ToDoApp
//
//  Created by Jack Adams on 29/06/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import Foundation


class ToDoModelController {
    
    private var todos = [Todo(title: "Wiser Interview", desc: "Complete Wiser Video Interview", id: UUID()),
                 Todo(title: "Workout", desc: "Complete Daily Workout", id: UUID()),
                 Todo(title: "Write", desc: "Continue with latest chapter", id: UUID())]
    
    var numberOfTodos: Int {
        return todos.count
    }
    
    private func getAllTodos() -> [Todo] {
        return todos
    }
    
    
    func getTodo(atIndex index: Int) -> Todo {
        return todos[index]
    }
    
    func addTodo(withTitle title: String, desc: String?) {
        let newTodo = Todo(title: title, desc: desc)
        todos += [newTodo]
    }
    
    private func deleteTodo(withIdentifier id: UUID) {
        
    }
    
    private func editTodo(withIdentifier id: String) {
        
    }
}
