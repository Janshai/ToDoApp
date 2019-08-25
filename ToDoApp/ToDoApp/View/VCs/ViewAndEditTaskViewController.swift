//
//  ViewAndEditTaskViewController.swift
//  ToDoApp
//
//  Created by Jack Adams on 27/07/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import UIKit

class ViewAndEditTaskViewController: UIViewController {
    
    var todo: Todo!
    var taskIndex: Int!
    var todoModelController: ToDoModelController!
    var categoryModelController: CategoryModelController!
    var changed = false
    var callback: ((Bool) -> Void)?
    
    
    var isEditingTodo = false {
        didSet {
            if isEditingTodo {
                editButton.setTitle("Save", for: .normal)
                closeButton.setTitle("Cancel", for: .normal)
                titleTextView.isEditable = true
                titleTextView.isSelectable = true
                UIView.animate(withDuration: 0.2, animations: {
                    self.titleTextView.backgroundColor = #colorLiteral(red: 0.9122217413, green: 0.9212536397, blue: 0.9212536397, alpha: 1)
                })
                
                
            } else {
                editButton.setTitle("Edit", for: .normal)
                closeButton.setTitle("Close", for: .normal)
                titleTextView.isEditable = false
                titleTextView.isSelectable = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.titleTextView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                })
            }
        }
    }
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    
    
    @IBAction func touchClose(_ sender: UIButton) {
        if isEditingTodo {
            titleTextView.text = todo.title
            isEditingTodo = !isEditingTodo
        } else {
            dismiss(animated: true, completion: nil)
        }
        
    }
    @IBAction func touchEdit(_ sender: UIButton) {
        if isEditingTodo {
            // create dict of values
            let dict = createNewValuesDict()
            changed = true
            //call edit todo on model controller
            todoModelController.editTodo(withIdentifier: todo.id, andNewValues: dict) {_ in}
        }
        isEditingTodo = !isEditingTodo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todo = todoModelController.getTodo(atIndex: taskIndex)
        
        titleTextView.text = todo.title
        titleTextView.delegate = self
        titleTextView.autocorrectionType = .no
        titleTextView.layer.cornerRadius = 5.0
        titleTextView.layer.borderColor = UIColor.lightGray.cgColor
        titleTextView.layer.borderWidth = 1.0
        titleTextView.doneAccessory = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let completion = callback {
            completion(changed)
        }
    }
    
    func createNewValuesDict() -> [TodoFields:Encodable] {
        var dict: [TodoFields:Encodable] = [:]
        if titleTextView.text != todo.title {
            dict[.title] = titleTextView.text
        }
        
        return dict
    }

}

extension ViewAndEditTaskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
//        let size = CGSize(width: popUpView.frame.width - 30, height: popUpView.frame.height)
//        let estimatedSize = textView.sizeThatFits(size)
//        print(estimatedSize)
//        if UIDevice.current.orientation.isLandscape {
//            textView.isScrollEnabled = estimatedSize.height > 150
//        } else {
//            textView.isScrollEnabled = estimatedSize.height > 320
//        }
//
//        textView.constraints.forEach({(constraint) in
//            if !textView.isScrollEnabled {
//                if constraint.firstAttribute == .height {
//                    constraint.constant = estimatedSize.height
//                }
//            }
//        })
    }
}


