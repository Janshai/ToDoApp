//
//  TaskTableView.swift
//  ToDoApp
//
//  Created by Jack Adams on 18/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    var primaryCategoryViewModel: CategoryViewModel! {
        didSet {
            self.primaryCategoryLabel.isHidden = !primaryCategoryViewModel.isDisplayingOnTask
            self.emojiLabel.text = primaryCategoryViewModel.emoji
            self.contentView.backgroundColor = primaryCategoryViewModel.backgroundColour
        }
    }

    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var primaryCategoryLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class TaskTableView {
    class func categoryEditSwipe(forTableView tableView: UITableView, forRowAt indexPath: IndexPath, withAction action: (Category) -> Void) -> UISwipeActionsConfiguration {
        let editAction = contextualEditCategoryAction(forTableView: tableView, forRowAt: indexPath, withAction: action)
        let swipeAction = UISwipeActionsConfiguration(actions: [editAction])
        swipeAction.performsFirstActionWithFullSwipe = true
        return swipeAction
    }
    
    class private func contextualEditCategoryAction(forTableView tableView: UITableView, forRowAt indexPath: IndexPath, withAction action: (Category) -> Void) -> UIContextualAction {
//        let category = categoryModelController.getCategory(atIndex: indexPath.row)
        let action = UIContextualAction(style: .normal, title: "X") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
//            action(category)
            tableView.reloadRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        action.backgroundColor = #colorLiteral(red: 0.1932181939, green: 0.660575954, blue: 1, alpha: 1)
        action.image = UIImage(named: "EditIcon")
        
        return action
    }
    
    class func categoryDeleteSwipe(forTableView tableView: UITableView, forRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration {
        let deleteAction = contextualCategoryDeletionAction(forTableView: tableView, forRowAt: indexPath)
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeAction.performsFirstActionWithFullSwipe = true
        return swipeAction
    }
    
    class private func contextualCategoryDeletionAction(forTableView tableView: UITableView, forRowAt indexPath: IndexPath) -> UIContextualAction {
        
//        let category = categoryModelController.getCategory(atIndex: indexPath.row)
        let action = UIContextualAction(style: .normal, title: "X") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
//            self.categoryModelController.deleteCategory(withID: category.id)
            tableView.deleteRows(at: [indexPath], with: .right)
            completionHandler(true)
        }
        action.backgroundColor = #colorLiteral(red: 1, green: 0.20458019, blue: 0.1013487829, alpha: 1)
        return action
    }
}
