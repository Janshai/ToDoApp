//
//  AddToDoViewController.swift
//  ToDoApp
//
//  Created by Jack Adams on 30/06/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import UIKit
class TaskViewController: UIViewController {
    
    var callback: ((Bool) -> Void)?
    var function: TaskVCFunction!
    
    private var taskViewModel: TaskViewModel?
    private var categoryViewModels = [CategoryViewModel]()
    private var isAddingCategory = false
    
    @IBOutlet weak private var headerView: UIView!
    @IBOutlet weak private var headerLabel: UILabel!
    @IBOutlet weak private var TitleTextField: UITextField!
    @IBOutlet weak private var categoriesCollectionView: UICollectionView!
    @IBOutlet weak private var headerButton: UIButton!
    
    @IBAction private func touchHeaderButton(_ sender: UIButton) {
        
        if let task = taskViewModel {
            
            let values = createEditedValuesDict()
            task.edit(withNewValues: values) { result in
                switch result {
                case .success(_):
                    self.callback?(true)
                case .failure(_):
                    self.callback?(false)
                }
            }
            
        } else {
            let values = createAddValuesDict()
            
            DispatchQueue.global(qos: .userInitiated).async {
                //TODO: pop up an error message if the todo doesn't add correctly and handle that.
                TaskViewModel.addTask(withValues: values) { success in self.callback?(success) }
            }
        }
        
        
        
        hideKeyboard()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func touchCancelButton(_ sender: UIButton) {
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
        
        categoryViewModels = CategoryModelController.shared.getAllCategoryViewModels()
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
        if taskViewModel != nil {
            headerLabel.text = "Edit Task"
            headerButton.setTitle("", for: .normal)
            headerButton.setImage(UIImage(named: "TickIcon"), for: .normal)
            headerButton.imageView?.setImageColor(color: .white)
        }
    }

    
    private func hideKeyboard() {
        TitleTextField.resignFirstResponder()
    }
    
    
    private func addCategoryButtonTouched(_ sender: UIButton) {
        isAddingCategory = !isAddingCategory
        categoriesCollectionView.performBatchUpdates( {
            categoriesCollectionView.reloadSections(IndexSet(integer: 0))
        }, completion: nil)
    }
    
    
    private func createAddValuesDict() -> [TodoFields: Encodable] {
        var dict = [TodoFields: Encodable]()
        if let title = TitleTextField.text {
            dict[.title] = title
        }
        
        return dict
    }
    
    private func createEditedValuesDict() -> [TodoFields: Encodable] {
        var dict = [TodoFields: Encodable]()
        if let title = TitleTextField.text, title != taskViewModel?.title {
            dict[.title] = title
        }
        
        return dict
    }
        

}

extension TaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
}

extension TaskViewController: UICollectionViewDataSource, UICollectionViewDelegate {
   
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
