//
//  EditCategoryViewController.swift
//  ToDoApp
//
//  Created by Jack Adams on 20/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import UIKit

class EditCategoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    var category: Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = 8.0
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
    
}

extension EditCategoryViewController: UITableViewDelegate {
    
}

extension EditCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "name") as? NameTableViewCell {
                cell.textField.text = category.name
                return cell
                
            }
        case 1: break
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "emoji") as? EmojiPickerTableViewCell {
                return cell
            }
        default: break
        }
        return UITableViewCell()
    }
    
    
}

