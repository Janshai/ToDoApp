//
//  AddToDoViewController.swift
//  ToDoApp
//
//  Created by Jack Adams on 30/06/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import UIKit
class AddToDoViewController: UIViewController {
    @IBOutlet weak var PopUpBoxView: UIView!
    @IBOutlet weak var AddToDoLabel: UILabel!
    @IBOutlet weak var TitleTextField: UITextField!
    
    
    @IBAction func touchPlusButton(_ sender: UIButton) {
        
        if let presenter = presentingViewController as? TasksTableViewController {
            if let input = TitleTextField.text {
                presenter.addNewTask(withTitle: input)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        PopUpBoxView.layer.masksToBounds = true
        PopUpBoxView.layer.cornerRadius = 6.0
        PopUpBoxView.layer.borderWidth = 0.3
        PopUpBoxView.layer.borderColor = UIColor.black.cgColor
        AddToDoLabel.layer.masksToBounds = true
        AddToDoLabel.layer.cornerRadius = 3.0
        AddToDoLabel.layer.borderWidth = 0.3
        AddToDoLabel.layer.borderColor = UIColor.black.cgColor
        
        TitleTextField.borderStyle = .roundedRect
        TitleTextField.autocorrectionType = .no
        TitleTextField.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowOrChangeFrame(notification:)), name: UIResponder.keyboardWillShowNotification
            , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowOrChangeFrame(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func handleKeyboardShowOrChangeFrame(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let height = keyboardFrame.cgRectValue.height
            self.view.frame.origin.y = -(height)
        }
    }
    
    @objc func handleKeyboardHide(notification: Notification) {
        self.view.frame.origin.y = 0
    }

}

extension AddToDoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        TitleTextField.resignFirstResponder()
        return true
    }
}
