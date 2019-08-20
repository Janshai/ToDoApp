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
    var selectRowFunc: ((UITableView, TaskDisplay) -> Void)?
    var editCategoryBehaviour: ((Category) -> Void)?
    
    init(tableView:UITableView, categoryModelController: CategoryModelController, selectRowAction:  ((UITableView, TaskDisplay) -> Void)?, editBehaviour: ((Category) -> Void)?) {
        self.categoryModelController = categoryModelController
        self.selectRowFunc = selectRowAction
        self.editCategoryBehaviour = editBehaviour
        super.init()
        tableView.delegate = self
    }
    
    private func contextualDeletionAction(forTableView tableView: UITableView, forRowAt indexPath: IndexPath) -> UIContextualAction {
        
        let category = categoryModelController.getCategory(atIndex: indexPath.row)
        let action = UIContextualAction(style: .normal, title: "X") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            self.categoryModelController.deleteCategory(withID: category.id)
            tableView.deleteRows(at: [indexPath], with: .right)
            completionHandler(true)
        }
        action.backgroundColor = #colorLiteral(red: 1, green: 0.20458019, blue: 0.1013487829, alpha: 1)
        return action
    }
    
    private func contextualEditAction(forTableView tableView: UITableView, forRowAt indexPath: IndexPath) -> UIContextualAction {
        let category = categoryModelController.getCategory(atIndex: indexPath.row)
        let action = UIContextualAction(style: .normal, title: "X") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            if let setEditCategoryBehaviour = self.editCategoryBehaviour {
                setEditCategoryBehaviour(category)
            }
            tableView.reloadRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        action.backgroundColor = #colorLiteral(red: 0.1932181939, green: 0.660575954, blue: 1, alpha: 1)
        action.image = UIImage(named: "EditIcon")
        
        return action
    }
}

extension MMTableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let strongSelectAction = selectRowFunc {
            var displayType: TaskDisplay
            switch indexPath.section {
            case 1:
                let category = categoryModelController.getCategory(atIndex: indexPath.row)
                displayType = .category(category)
            default:
                displayType = .allTodos
            }
            strongSelectAction(tableView, displayType)
        }
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        switch indexPath.section {
        case 1:
            let deleteAction = contextualDeletionAction(forTableView: tableView, forRowAt: indexPath)
            let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
            swipeAction.performsFirstActionWithFullSwipe = true
            return swipeAction
        default:
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let emptySwipe = UISwipeActionsConfiguration(actions: [])
        switch indexPath.section {
        case 1:
            if editCategoryBehaviour != nil {
                let editAction = contextualEditAction(forTableView: tableView, forRowAt: indexPath)
                let swipeAction = UISwipeActionsConfiguration(actions: [editAction])
                swipeAction.performsFirstActionWithFullSwipe = true
                return swipeAction
            } else {
                return emptySwipe
            }
            
        default:
            return emptySwipe
        }
    }
    
    
}
