//
//  Todo-Model.swift
//  ToDoApp
//
//  Created by Jack Adams on 29/06/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import Foundation


class ToDoModelController {
    
    private var todos = [Todo(title: "Wiser Interview",  id: UUID()),
                 Todo(title: "Workout", id: UUID()),
                 Todo(title: "Write", id: UUID())]
    
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
        let newTodo = Todo(title: title, id: UUID())
        todos += [newTodo]
    }
    
    func deleteTodo(withIdentifier id: UUID) {
        todos.removeAll(where: {$0.id == id})
    }
    
    func editTodo(withIdentifier id: UUID, toNowEqual newTodo: Todo) {
        let todo = todos.first(where: {$0.id == id})
        todo?.title = newTodo.title
        
        
    }
}
