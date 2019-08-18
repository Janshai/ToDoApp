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
    private var categoryModelController: CategoryModelController
    
    init(tableview: UITableView, toDoModelController: ToDoModelController, categoryModelController: CategoryModelController) {
        self.toDoModelController = toDoModelController
        self.categoryModelController = categoryModelController
        super.init()
        tableview.dataSource = self
        
        
    }
}

extension ToDoTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoModelController.numberOfTodos
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as? TodoTableViewCell {
            let todo = toDoModelController.getTodo(atIndex: indexPath.row)
            cell.taskTitleLabel.text = todo.title
            if todo.categoryIDs.count > 0, let category = categoryModelController.getCategory(withID: todo.categoryIDs[0]) {
                cell.primaryCategoryLabel.text = category.name
                cell.emojiLabel.text = "😀"
            } else {
                cell.primaryCategoryLabel.text = ""
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let errorCell = UITableViewCell(style: .default, reuseIdentifier: nil)
            errorCell.textLabel?.text = toDoModelController.getTodo(atIndex: indexPath.row).title
            errorCell.selectionStyle = .none
            return errorCell
        }
        
    }
    
    
}
