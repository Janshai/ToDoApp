//
//  EditCategoryViewController.swift
//  ToDoApp
//
//  Created by Jack Adams on 20/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
//
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var headerView: UIView!
//    @IBOutlet weak var confirmButton: UIButton!
//    @IBOutlet weak var titleLabel: UILabel!
//
//    @IBAction func tapConfirmButton(_ sender: UIButton) {
//
//        dismiss(animated: true, completion: completion)
//    }
//
//    var category: Category!
//    var completion: (() -> Void)!
//    var function: CategoryVCFunction!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
//
//        setupHeaderView()
//
//        self.completion = {}
//
//    }
//
//    func setupHeaderView() {
//        headerView.clipsToBounds = true
//        headerView.layer.cornerRadius = 8.0
//        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        switch function! {
//        case .add:
//            titleLabel.text = "Add Category"
//        case .edit:
//            titleLabel.text = "Edit Category"
//        }
//        confirmButton.imageView?.setImageColor(color: .white)
//    }
//
//}
//
//extension CategoryViewController: UITableViewDelegate {
//
//}
//
//extension CategoryViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let isEditing = function! == .edit
//        switch indexPath.row {
//        case 0:
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "name") as? NameTableViewCell {
//                cell.textField.text = isEditing ? category.name : ""
//                cell.textField.placeholder = isEditing ? "" : "Category Name"
//                return cell
//
//            }
//        case 1:
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "colour") as? ColourPickerTableViewCell {
//                cell.colourField.backgroundColor = isEditing ? category.UIColor() : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//                return cell
//            }
//        case 2:
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "emoji") as? EmojiPickerTableViewCell {
//                cell.textField.text = isEditing ? category.emoji : ""
//                return cell
//            }
//        default: break
//        }
//        return UITableViewCell()
//    }
    
    
}

extension CategoryViewController:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

enum CategoryVCFunction {
    case add
    case edit
}

