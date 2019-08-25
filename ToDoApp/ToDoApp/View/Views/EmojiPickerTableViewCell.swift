//
//  EmojiPickerTableViewCell.swift
//  ToDoApp
//
//  Created by Jack Adams on 20/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import UIKit
import ISEmojiView

class EmojiPickerTableViewCell: UITableViewCell {
    
    var categoryViewModel: CategoryViewModel? {
        didSet {
            textField.text = categoryViewModel?.emoji
        }
    }

    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupTextField()
        
    }
    
    private func setupTextField() {
        let keyboardSettings = KeyboardSettings(bottomType: .categories)
        let emojiView = EmojiView(keyboardSettings: keyboardSettings)
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.delegate = self
        textField.inputView = emojiView
        textField.doneAccessory = true
        textField.clearsOnBeginEditing = true
        textField.borderStyle = .roundedRect
        textField.text = ""
    }


}

extension EmojiPickerTableViewCell: EmojiViewDelegate {
    func emojiViewDidSelectEmoji(_ emoji: String, emojiView: EmojiView) {
        textField.insertText(emoji)
        textField.resignFirstResponder()
    }
    
    
}
