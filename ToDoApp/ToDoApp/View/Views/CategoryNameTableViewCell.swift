//
//  NameTableViewCell.swift
//  ToDoApp
//
//  Created by Jack Adams on 20/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import UIKit

class CategoryNameTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    var categoryViewModel: CategoryViewModel? {
        didSet {
            self.textField.text = categoryViewModel?.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.doneAccessory = true
        textField.autocorrectionType = .no
        textField.borderStyle = .roundedRect
        textField.placeholder = "Category Name"
    }


}
