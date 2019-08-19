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
    private var displaying: TaskDisplay
    
    init(tableview: UITableView, toDoModelController: ToDoModelController, categoryModelController: CategoryModelController, displaying: TaskDisplay) {
        self.toDoModelController = toDoModelController
        self.categoryModelController = categoryModelController
        self.displaying = displaying
        super.init()
        tableview.dataSource = self
        
        
    }
    
    private func createCorrectFilter() -> ((Todo) -> Bool)? {
        var filter: ((Todo) -> Bool)?
        switch displaying {
        case .allTodos:
            filter = nil
        case .category(let category):
            filter = { todo in
                return todo.categoryIDs.contains(category.id)
            }
        }
        
        return filter
    }
}

extension ToDoTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoModelController.numberOfTodos(applyingFilter: createCorrectFilter())
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TodoTableViewCell {
            
            let todo = toDoModelController.getTodo(atIndex: indexPath.row, applyingFilter: createCorrectFilter())
            cell.taskTitleLabel.text = todo.title
            if todo.categoryIDs.count > 0, let category = categoryModelController.getCategory(withID: todo.categoryIDs[0]) {
                cell.primaryCategoryLabel.text = category.name
                cell.emojiLabel.text = "😀"
            } else {
                cell.primaryCategoryLabel.text = ""
                cell.emojiLabel.text = ""
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
