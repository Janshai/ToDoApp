//
//  TaskTableView.swift
//  ToDoApp
//
//  Created by Jack Adams on 18/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    var categoryViewModel: CategoryViewModel! {
        didSet {
            self.taskTitleLabel.text = categoryViewModel.name
            self.primaryCategoryLabel.isHidden = true
            self.emojiLabel.text = categoryViewModel.emoji
            self.backgroundColor = categoryViewModel.backgroundColour
        }
    }
    
    var taskViewModel: TaskViewModel! {
        didSet {
            taskTitleLabel.text = taskViewModel.title
            primaryCategoryLabel.text = taskViewModel.primaryCategory?.name
            emojiLabel.text = taskViewModel.primaryCategory?.emoji
            self.backgroundColor = taskViewModel.primaryCategory?.backgroundColour ?? UIColor.white
        }
    }

    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var primaryCategoryLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).withAlphaComponent(0.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class TaskTableView {
    private static var categoryModelController = CategoryModelController()
    
    class func categoryEditSwipe(forTableView tableView: UITableView, forRowAt indexPath: IndexPath, withAction action: @escaping (CategoryViewModel) -> Void) -> UISwipeActionsConfiguration {
        let editAction = contextualEditCategoryAction(forTableView: tableView, forRowAt: indexPath, withAction: action)
        return createSingleSwipe(withContextualAction: editAction)
    }
    
    class private func contextualEditCategoryAction(forTableView tableView: UITableView, forRowAt indexPath: IndexPath, withAction editAction: @escaping (CategoryViewModel) -> Void) -> UIContextualAction {
        let categoryViewModel = categoryModelController.getCategoryViewModel(atIndex: indexPath.row)
        let action = UIContextualAction(style: .normal, title: "X") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            editAction(categoryViewModel)
            tableView.reloadRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        action.backgroundColor = #colorLiteral(red: 0.1932181939, green: 0.660575954, blue: 1, alpha: 1)
        action.image = UIImage(named: "EditIcon")
        
        return action
    }
    
    class func categoryDeleteSwipe(forCategory category: CategoryViewModel, onTableView tableView: UITableView, forRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration {
    
        let deleteAction = createDeletionAction(forTableView: tableView, forRowAt: indexPath) {
            category.delete()
        }
        return createSingleSwipe(withContextualAction: deleteAction)
    }
    
    
    class func taskDeleteSwipe(forTask task: TaskViewModel, onTableView tableView: UITableView, forRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration {
        
        let deleteAction = createDeletionAction(forTableView: tableView, forRowAt: indexPath) {
            task.delete()
        }
        return createSingleSwipe(withContextualAction: deleteAction)
    }
    
    class func taskCompleteSwipe(forTask task: TaskViewModel, onTableView tableView: UITableView, forRowAt indexPath: IndexPath)  -> UISwipeActionsConfiguration{
        let completeAction = contextualCompletionAction(forTask: task, onTableView: tableView, forRowAt: indexPath)
        return createSingleSwipe(withContextualAction: completeAction)
    }
    
    class private func createDeletionAction(forTableView tableView: UITableView, forRowAt indexPath: IndexPath, withDeleteAction deleteAction: @escaping () -> Void) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "X") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            deleteAction()
            tableView.deleteRows(at: [indexPath], with: .right)
            completionHandler(true)
        }
        action.backgroundColor = #colorLiteral(red: 1, green: 0.20458019, blue: 0.1013487829, alpha: 1)
        return action
    }
    
    class private func contextualCompletionAction(forTask task: TaskViewModel, onTableView tableView: UITableView, forRowAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Complete") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            task.delete()
            tableView.deleteRows(at: [indexPath], with: .left)
            completionHandler(true)
        }
        action.image = UIImage(named: "TickIcon")
        action.backgroundColor = #colorLiteral(red: 0.001046009478, green: 0.8197078109, blue: 0, alpha: 1)
        return action
    }
    
    class private func createSingleSwipe(withContextualAction action: UIContextualAction) -> UISwipeActionsConfiguration {
        let swipeAction = UISwipeActionsConfiguration(actions: [action])
        swipeAction.performsFirstActionWithFullSwipe = true
        return swipeAction
    }
    
    
}
