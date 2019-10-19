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
    private var categoryViewModel: CategoryViewModel?
    var completion: ((Bool) -> Void)!
    var function: CategoryVCFunction!
    
    // MARK: Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    //MARK: Actions
    
    @IBAction func tapConfirmButton(_ sender: UIButton) {
        if let category = categoryViewModel {
            category.updateModel() { success in
                self.completion(success)
            }
        } else {
            let values = createAddValuesDict()
            CategoryViewModel.addCategory(withValues: values) { success in
                self.completion(success)
            }
        }
        dismiss(animated: true, completion: { self.categoryViewModel?.reset() })
    }
    
    //MARK: VC Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch function! {
        case .edit(let vm):
            categoryViewModel = vm
        default:
            break
        }
        
        tableView.delegate = self
        tableView.dataSource = self

        setupHeaderView()

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
    
    private func createAddValuesDict() -> [CategoryFields:Encodable] {
        var dict = [CategoryFields:Encodable]()
        if let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CategoryNameTableViewCell, let name = nameCell.textField.text {
            
            dict[.name] = name
        }
        
        if let colourCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ColourPickerTableViewCell, let uiColor = colourCell.colourField.backgroundColor, let categoryColour = Config.categoryColours.first(where: {$0.colour == uiColor})?.name.rawValue {
            
            dict[.colour] = categoryColour
        }
        
        if let emojiCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? EmojiPickerTableViewCell, let emoji = emojiCell.textField.text {
            
            dict[.emoji] = emoji
        }
        
        return dict
    }

}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "name") as! CategoryNameTableViewCell
            cell.categoryViewModel = categoryViewModel
            return cell
                
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "colour") as! ColourPickerTableViewCell
            cell.categoryViewModel = categoryViewModel
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "emoji") as! EmojiPickerTableViewCell
            cell.categoryViewModel = categoryViewModel
            return cell
            
        default: break
        }
        return UITableViewCell()
    }
    
    
}

//MARK: VC Function Enum

enum CategoryVCFunction {
    case add
    case edit(viewModel: CategoryViewModel)
}

