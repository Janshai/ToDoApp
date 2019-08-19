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
    
}

extension MMTableViewDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TodoTableViewCell {
            
            cell.taskTitleLabel.text = "All Todos"
            cell.primaryCategoryLabel.isHidden = true
            cell.emojiLabel.text = "📝"
            return cell
        } else {
            let backupCell = UITableViewCell(style: .default, reuseIdentifier: nil)
            backupCell.textLabel?.text = "All Todos"
            
            return backupCell
        }
    }
    
    
}
