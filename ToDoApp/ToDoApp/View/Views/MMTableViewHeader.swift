//
//  MMTableViewHeader.swift
//  ToDoApp
//
//  Created by Jack Adams on 21/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import UIKit

class MMTableViewHeader: UITableViewHeaderFooterView{
    
    static let reuseIdentifier = "Header"
    
    @IBAction func touchRightSideButton(_ sender: UIButton) {
        if let action = rightSideButtonAction {
            action(sender)
        }
    }
    @IBOutlet weak var rightSideButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    var rightSideButtonAction: ((UIButton) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
