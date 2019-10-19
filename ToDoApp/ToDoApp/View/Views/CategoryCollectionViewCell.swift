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
            self.layer.borderColor = categoryViewModel.borderColour.cgColor
            nameLabel.textColor = categoryViewModel.textColour
            
        }
    }
    
    func animateSelection() {
        UIView.animate(withDuration: 0.5) {
            self.backgroundColor = self.categoryViewModel.backgroundColour
            self.layer.borderColor = self.categoryViewModel.borderColour.cgColor
            self.nameLabel.textColor = self.categoryViewModel.textColour
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 12.0
        nameLabel.adjustsFontSizeToFitWidth = true
        self.layer.borderWidth = 1.0
    }
    
}


class CategoryCollectionViewHeader: UICollectionReusableView {

    @IBAction private func touchPlusButton(_ sender: UIButton) {
        touchedPlus(sender)
    }
    
    var touchedPlus: ((UIButton) -> Void)!

}

