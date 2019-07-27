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
    var desc: String?
    var id: UUID?
    init(title: String, desc: String?, id: UUID? = nil) {
        self.title = title
        self.desc = desc
        self.id = id
    }
}
