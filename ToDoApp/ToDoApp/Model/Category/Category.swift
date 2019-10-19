//
//  Category.swift
//  ToDoApp
//
//  Created by Jack Adams on 18/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import Foundation
import UIKit

class Category: Codable {
    
    public private(set) var id: String
    public var name: String
    public var colour: String
    public var emoji: String?
    
    init(name: String, colour: CategoryColours, emoji: String) {
        self.name = name
        self.id = UUID().uuidString
        self.colour = colour.rawValue
        self.emoji = emoji
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case colour
        case emoji
        case id = "_id"
    }
    
}
