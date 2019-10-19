//
//  CategoryResponse.swift
//  ToDoApp
//
//  Created by Jack Adams on 30/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import Foundation

class CategoryResponse: Decodable {
    var message: String
    var success: Bool
    var error: String?
    var category: Category?
    var categories: [Category]?
}
