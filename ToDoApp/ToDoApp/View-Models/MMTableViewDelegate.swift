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
    var addCategoryBehaviour: (() -> Void)?
    
    init(tableView:UITableView, categoryModelController: CategoryModelController, selectRowAction:  ((UITableView, TaskDisplay) -> Void)?, editBehaviour: ((Category) -> Void)?, addBehaviour: (() -> Void)?) {
        self.categoryModelController = categoryModelController
        self.selectRowFunc = selectRowAction
        self.editCategoryBehaviour = editBehaviour
        self.addCategoryBehaviour = addBehaviour
        super.init()
        tableView.delegate = self
    }
    
    
    
    private func setupCategoriesHeader(forTableView tableView: UITableView) -> UIView? {
        if let view = tableView.dequeueReusableCell(withIdentifier: "header") as? MMTableViewHeader {
            
            view.rightSideButtonAction = { button in
                if let action = self.addCategoryBehaviour {
                    action()
                }
            }
            
            view.nameLabel.text = "CATEGORIES"
            view.contentView.backgroundColor = tableView.backgroundColor
            
            return view
        } else {
            return nil
        }
        
        
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
            return TaskTableView.categoryDeleteSwipe(forTableView: tableView, forRowAt: indexPath)
        default:
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let emptySwipe = UISwipeActionsConfiguration(actions: [])
        switch indexPath.section {
        case 1:
            if editCategoryBehaviour != nil {
                return TaskTableView.categoryEditSwipe(forTableView: tableView, forRowAt: indexPath, withAction: editCategoryBehaviour!)
            } else {
                return emptySwipe
            }
            
        default:
            return emptySwipe
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            return setupCategoriesHeader(forTableView: tableView)
        default:
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    
}
