//
//  AddToDoViewController.swift
//  ToDoApp
//
//  Created by Jack Adams on 30/06/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import UIKit
class AddToDoViewController: UIViewController {
    
    
    var categoryModelController: CategoryModelController!
    var callback: ((Bool) -> Void)?
    var function: TaskVCFunction!
    
    private var taskViewModel: TaskViewModel?
    private var categoryViewModels = [CategoryViewModel]()
    private var isAddingCategory = false
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var TitleTextField: UITextField!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    
    @IBAction func touchPlusButton(_ sender: UIButton) {
        
        if let title = self.TitleTextField.text {
            DispatchQueue.global(qos: .userInitiated).async {
                //TODO: pop up an error message if the todo doesn't add correctly and handle that.
               
                TaskViewModel.addTask(withTitle: title) { success in
                    if let completion = self.callback {
                        completion(success)
                    }
                }
            }
        }
        hideKeyboard()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchCancelButton(_ sender: UIButton) {
        hideKeyboard()
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch function! {
        case .edit(let vm):
            taskViewModel = vm
        default:
            break
        }
        
        setupTitleTextField()
        setupHeaderView()
        
        self.categoriesCollectionView.dataSource = self
        self.categoriesCollectionView.delegate = self
        
        categoryViewModels = categoryModelController.getAllCategoryViewModels()
        //TODO: if the task view model is set, add all the categories
        
    }
    
    private func setupTitleTextField() {
        TitleTextField.borderStyle = .roundedRect
        TitleTextField.autocorrectionType = .no
        TitleTextField.delegate = self
        TitleTextField.doneAccessory = true
        if let task = taskViewModel {
            TitleTextField.text = task.title
        }
    }
    
    private func setupHeaderView() {
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = 8.0
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerLabel.text = taskViewModel == nil ? "Add Task" : "Edit Task"
    }

    
    private func hideKeyboard() {
        TitleTextField.resignFirstResponder()
    }
    
    
    func addCategoryButtonTouched(_ sender: UIButton) {
        isAddingCategory = !isAddingCategory
        categoriesCollectionView.performBatchUpdates( {
            categoriesCollectionView.reloadSections(IndexSet(integer: 0))
        }, completion: nil)
    }
    

}

extension AddToDoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
}

extension AddToDoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isAddingCategory ? categoryViewModels.count
            : categoryViewModels.filter({ $0.isCurrentlySelectedForTask }).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var categoryViewModel: CategoryViewModel
        let itemIndex = indexPath.item

        if isAddingCategory {
            categoryViewModel = categoryViewModels[itemIndex]
        } else {
            categoryViewModel = categoryViewModels.filter({ $0.isCurrentlySelectedForTask })[itemIndex]
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        cell.categoryViewModel = categoryViewModel
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as? CategoryCollectionViewHeader

        headerView?.frame.size.height = 50
        headerView?.touchedPlus = addCategoryButtonTouched(_:)
        return headerView!
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isAddingCategory {
            let cell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
            let categoryViewModel = categoryViewModels[indexPath.item]
            categoryViewModel.isCurrentlySelectedForTask = !categoryViewModel.isCurrentlySelectedForTask
            cell.animateSelection()
        }
    }
}

enum TaskVCFunction {
    case add
    case edit(viewModel: TaskViewModel)
}
