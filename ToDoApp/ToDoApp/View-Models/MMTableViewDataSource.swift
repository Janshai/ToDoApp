//
//  MMTableViewDataSource.swift
//  ToDoApp
//
//  Created by Jack Adams on 19/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import Foundation
import UIKit

class MMTableViewDataSource: NSObject {
    
    private var categoryModel: CategoryModelController
    
    init(tableView: UITableView, categoryModelController: CategoryModelController) {
        self.categoryModel = categoryModelController
        super.init()
        tableView.dataSource = self
    }
    
}

extension MMTableViewDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return categoryModel.numberOfCategories
        default:
            return 0
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let backupCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        backupCell.textLabel?.text = "Error"
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TodoTableViewCell {
            cell.primaryCategoryLabel.isHidden = true
            
            switch indexPath.section {
            case 0:
                cell.taskTitleLabel.text = "All Todos"
                cell.emojiLabel.text = "📝"
            case 1:
                let category = categoryModel.getCategory(atIndex: indexPath.row)
                cell.taskTitleLabel.text = category.name
                cell.emojiLabel.text = "🔓"
            default:
                return backupCell
            }
            
            return cell
        } else {
            return backupCell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Categories"
        default:
            return nil
        }
    }
    
    
}
