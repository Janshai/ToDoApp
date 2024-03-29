//
//  Todo.swift
//  ToDoApp
//
//  Created by Jack Adams on 29/06/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import Foundation

class Todo: Codable {
    public var title: String
    public private(set) var id: String
    public private(set) var createdAt: Date
    
    init(title: String, id: String? = nil, createdAt: Date? = nil) {
        self.title = title
        self.id = id ?? UUID().uuidString
        self.createdAt = createdAt ?? Date()
    }
    
    private enum CodingKeys: String, CodingKey {
        case title
        case id = "_id"
        case createdAt
    }
}
