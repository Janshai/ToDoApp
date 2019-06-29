//
//  ToDoTableViewDataSource.swift
//  ToDoApp
//
//  Created by Jack Adams on 29/06/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import Foundation
import UIKit

class ToDoTableViewDataSource: NSObject {
    
    private var toDoModelController: ToDoModelController
    
    init(tableview: UITableView, toDoModelController: ToDoModelController) {
        self.toDoModelController = toDoModelController
        super.init()
        tableview.dataSource = self
        
    }
}

extension ToDoTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoModelController.numberOfTodos
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = toDoModelController.getTodo(atIndex: indexPath.row).title
        return cell
    }
    
    
}
