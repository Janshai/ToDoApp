//
//  MMTableViewDelegate.swift
//  ToDoApp
//
//  Created by Jack Adams on 19/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import Foundation
import UIKit

class MMTableViewDelegate: NSObject {
    
    var categoryModelController: CategoryModelController
    var selectRowFunc: (UITableView, TaskDisplay) -> Void
    
    init(tableView:UITableView, categoryModelController: CategoryModelController, selectRowAction: @escaping (UITableView, TaskDisplay) -> Void) {
        self.categoryModelController = categoryModelController
        self.selectRowFunc = selectRowAction
        super.init()
        tableView.delegate = self
    }
    
}

extension MMTableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var displayType: TaskDisplay
        switch indexPath.section {
        case 1:
            let category = categoryModelController.getCategory(atIndex: indexPath.row)
            displayType = .category(category)
        default:
            displayType = .allTodos
        }
        selectRowFunc(tableView, displayType)
    }
}
