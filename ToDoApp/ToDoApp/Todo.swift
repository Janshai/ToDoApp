//
//  Todo.swift
//  ToDoApp
//
//  Created by Jack Adams on 29/06/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import Foundation

class Todo {
    var title: String
    var id: UUID
    init(title: String, id: UUID? = nil) {
        self.title = title
        self.id = id ?? UUID()
    }
}
