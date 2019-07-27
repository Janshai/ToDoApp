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
        
        
        
    }
    
    
    
}
