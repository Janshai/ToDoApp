//
//  ColourPickerTableViewCell.swift
//  ToDoApp
//
//  Created by Jack Adams on 20/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import UIKit

class ColourPickerTableViewCell: UITableViewCell {
    
    let colours = Config.categoryColours
    var categoryViewModel: CategoryViewModel? {
        didSet {
            colourField.backgroundColor = categoryViewModel?.foregroundColour
        }
    }

  
    @IBOutlet weak var colourField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        colourField.borderStyle = .roundedRect
        colourField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        createPicker()
        
    }
    
    func createPicker() {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        colourField.inputView = picker
        createToolbar()
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissPicker))
        
        toolBar.setItems([flexSpace, done], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        colourField.inputAccessoryView = toolBar
    }
    
    @objc func dismissPicker() {
        colourField.endEditing(true)
    }

}

extension ColourPickerTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colours.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = NSAttributedString(string: colours[row].name.rawValue)
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        colourField.backgroundColor = colours[row].colour
    }
    
    
}
