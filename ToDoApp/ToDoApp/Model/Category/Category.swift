//
//  Category.swift
//  ToDoApp
//
//  Created by Jack Adams on 18/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import Foundation

class Category: Codable {
    
    public private(set) var id: String
    public var name: String
    
    init(name: String) {
        self.name = name
        self.id = UUID().uuidString
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case id = "_id"
    }
}
