//
//  TodoResponse.swift
//  ToDoApp
//
//  Created by Jack Adams on 16/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import Foundation

class TodoResponse: Decodable {
    var message: String
    var success: Bool
    var error: String?
    var todo: Todo?
    var todos: [Todo]?
}
