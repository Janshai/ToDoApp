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
    var changed = false
    var callback: ((Bool) -> Void)?
    
    var isEditingTodo = false {
        didSet {
            if isEditingTodo {
                editButton.setTitleColor(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), for: .normal)
                editButton.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                editButton.setTitle("Save", for: .normal)
                closeButton.setTitle("Cancel", for: .normal)
                titleTextView.isEditable = true
                titleTextView.isSelectable = true
                UIView.animate(withDuration: 0.2, animations: {
                    self.titleTextView.backgroundColor = #colorLiteral(red: 0.9122217413, green: 0.9212536397, blue: 0.9212536397, alpha: 1)
                })
                
                
            } else {
                editButton.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), for: .normal)
                editButton.layer.borderColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
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
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
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
        editButton.layer.cornerRadius = 5.0
        editButton.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), for: .normal)
        editButton.layer.borderColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        editButton.layer.borderWidth = 1.0
        closeButton.layer.cornerRadius = 5.0
        closeButton.setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: .normal)
        closeButton.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        closeButton.layer.borderWidth = 1.0
        popUpView.layer.cornerRadius = 5.0
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let completion = callback {
            completion(changed)
        }
    }
    

    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
        let size = CGSize(width: popUpView.frame.width - 30, height: popUpView.frame.height)
        let estimatedSize = textView.sizeThatFits(size)
        print(estimatedSize)
        if UIDevice.current.orientation.isLandscape {
            textView.isScrollEnabled = estimatedSize.height > 150
        } else {
            textView.isScrollEnabled = estimatedSize.height > 320
        }
        
        textView.constraints.forEach({(constraint) in
            if !textView.isScrollEnabled {
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        })
    }
}


