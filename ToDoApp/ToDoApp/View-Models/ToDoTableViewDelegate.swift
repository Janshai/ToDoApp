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
    
    private func contextualDeletionAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
        let todo = toDoModelController.getTodo(atIndex: indexPath.row)
        let action = UIContextualAction(style: .normal, title: "X") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            self.toDoModelController.deleteTodo(withIdentifier: todo.id) {_ in }
            self.vc.deleteTableViewData(atRow: indexPath, withAnimation: .left)
            completionHandler(true)
        }
        action.backgroundColor = #colorLiteral(red: 1, green: 0.20458019, blue: 0.1013487829, alpha: 1)
        return action
    }
    
    private func contextualCompletionAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
        let todo = toDoModelController.getTodo(atIndex: indexPath.row)
        let action = UIContextualAction(style: .normal, title: "Complete") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            self.toDoModelController.deleteTodo(withIdentifier: todo.id) {_ in }
            self.vc.deleteTableViewData(atRow: indexPath, withAnimation: .right)
            completionHandler(true)
        }
        action.image = UIImage(named: "TickIcon")
        action.backgroundColor = #colorLiteral(red: 0.001046009478, green: 0.8197078109, blue: 0, alpha: 1)
        return action
    }
}

extension ToDoTableViewDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vc.selectedTaskIndex = indexPath.row
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let completeAction = contextualCompletionAction(forRowAt: indexPath)
        let swipeAction = UISwipeActionsConfiguration(actions: [completeAction])
        swipeAction.performsFirstActionWithFullSwipe = true
        return swipeAction
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = contextualDeletionAction(forRowAt: indexPath)
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeAction.performsFirstActionWithFullSwipe = true
        return swipeAction
    }
    
}
