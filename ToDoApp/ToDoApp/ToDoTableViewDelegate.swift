//
//  ToDoTableViewDelegate.swift
//  ToDoApp
//
//  Created by Jack Adams on 29/06/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import Foundation
import UIKit

class ToDoTableViewDelegate: NSObject {
    var toDoModelController: ToDoModelController
    
    init(tableView: UITableView, toDoModelController: ToDoModelController) {
        self.toDoModelController = toDoModelController
        super.init()
        tableView.delegate = self
    }
}

extension ToDoTableViewDelegate: UITableViewDelegate {
    
}
