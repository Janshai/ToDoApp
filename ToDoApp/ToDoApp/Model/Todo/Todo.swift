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
    public var categoryIDs: [String]
    public private(set) var id: String
    public private(set) var createdAt: Date
    public var priority: taskPriority?
    public var points: taskPoints
    

    
    init(title: String, categories: [String] = [], id: String? = nil, createdAt: Date? = nil) {
        self.title = title
        self.id = id ?? UUID().uuidString
        self.createdAt = createdAt ?? Date()
        self.categoryIDs = categories
        self.points = .one
        self.priority = .low
    }
    
    private enum CodingKeys: String, CodingKey {
        case title
        case categoryIDs = "categories"
        case id = "_id"
        case createdAt
        case priority
        case points
    }
    
    
}

enum taskPriority: String, Codable {
    case high
    case mid
    case low
}

enum taskPoints: Int, Codable {
    case one = 1
    case two = 2
    case five = 5
    case eight = 8
    case twelve = 12
}
