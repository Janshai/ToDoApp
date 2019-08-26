//
//  CategoryCollectionViewCell.swift
//  ToDoApp
//
//  Created by Jack Adams on 18/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    var categoryViewModel: CategoryViewModel! {
        didSet {
            nameLabel.text = categoryViewModel.name
            self.backgroundColor = categoryViewModel.backgroundColour
            
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 12.0
        nameLabel.adjustsFontSizeToFitWidth = true
    }
    
}


class CategoryCollectionViewHeader: UICollectionReusableView {

    @IBAction private func touchPlusButton(_ sender: UIButton) {
        touchedPlus(sender)
    }
    
    var touchedPlus: ((UIButton) -> Void)!

}

