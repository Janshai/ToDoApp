//
//  EditCategoryViewController.swift
//  ToDoApp
//
//  Created by Jack Adams on 20/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import UIKit


class CategoryViewController: UIViewController {
    
    //MARK: Required Properties - Must be set by presenter or app will crash
    var categoryViewModel: CategoryViewModel!
    var completion: (() -> Void)!
    var function: CategoryVCFunction!
    
    // MARK: Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    //MARK: Actions
    
    @IBAction func tapConfirmButton(_ sender: UIButton) {

        dismiss(animated: true, completion: completion)
    }
    
    //MARK: VC Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        setupHeaderView()

        self.completion = {}

    }
    
    /// Sets up the header at the top of the view
    func setupHeaderView() {
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = 8.0
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        switch function! {
        case .add:
            titleLabel.text = "Add Category"
        case .edit:
            titleLabel.text = "Edit Category"
        }
        confirmButton.imageView?.setImageColor(color: .white)
    }

}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isEditing = function! == .edit
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "name") as! CategoryNameTableViewCell
            cell.categoryViewModel = isEditing ? categoryViewModel : nil
            return cell
                
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "colour") as! ColourPickerTableViewCell
            cell.categoryViewModel = isEditing ? categoryViewModel : nil
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "emoji") as! EmojiPickerTableViewCell
            cell.categoryViewModel = isEditing ? categoryViewModel : nil
            return cell
            
        default: break
        }
        return UITableViewCell()
    }
    
    
}

//MARK: VC Function Enum

enum CategoryVCFunction {
    case add
    case edit
}

