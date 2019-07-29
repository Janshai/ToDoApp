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
    var vc: TasksTableViewController
    
    init(tableView: UITableView, toDoModelController: ToDoModelController, vc: TasksTableViewController) {
        self.toDoModelController = toDoModelController
        self.vc = vc
        super.init()
        tableView.delegate = self
        
    }
}

extension ToDoTableViewDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vc.selectedTask = toDoModelController.getTodo(atIndex: indexPath.row)
    }
    
}
