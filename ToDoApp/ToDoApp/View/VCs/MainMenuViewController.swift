//
//  MainMenuViewController.swift
//  ToDoApp
//
//  Created by Jack Adams on 19/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    private let todoScreenSegue = "TodoScreen"
    private let CategorySegue = "Category"
    
    private var categoryModelController = CategoryModelController()
    private var categoryViewModels = [CategoryViewModel]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryViewModels = categoryModelController.getAllCategoryViewModels(forDisplayingOnMenu: true)
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == todoScreenSegue, let display = sender as? TaskDisplay, let todoVC = segue.destination as? TasksTableViewController {
            todoVC.displaying = display
            todoVC.categoryModelController = self.categoryModelController
        } else if segue.identifier == CategorySegue, let vc = segue.destination as? CategoryViewController {
//            if let category = sender as? Category {
//                vc.function = .edit
//                vc.category = category
//            } else {
//                vc.function = .add
//            }
        }
    }

}

extension MainMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return categoryViewModels.count
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TaskTableViewCell
        
        switch indexPath.section {
        case 0:
            cell.taskTitleLabel.text = "All Todos"
            cell.emojiLabel.text = "📝"
        case 1:
            let categoryViewModel = categoryViewModels[indexPath.row]
            cell.primaryCategoryViewModel = categoryViewModel
            
        default:
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var displayType: TaskDisplay
        switch indexPath.section {
        case 1:
            let category = categoryModelController.getCategory(atIndex: indexPath.row)
            displayType = .category(category)
        default:
            displayType = .allTodos
        }
        
        performSegue(withIdentifier: todoScreenSegue, sender: displayType)
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        switch indexPath.section {
        case 1:
            return TaskTableView.categoryDeleteSwipe(forTableView: tableView, forRowAt: indexPath)
        default:
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        switch indexPath.section {
        case 1:
            return TaskTableView.categoryEditSwipe(forTableView: tableView, forRowAt: indexPath) { category in
                
                self.performSegue(withIdentifier: self.CategorySegue, sender: category)
            }
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            return setupCategoriesHeader(forTableView: tableView)
        default:
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    private func setupCategoriesHeader(forTableView tableView: UITableView) -> UIView? {
        
        let view = tableView.dequeueReusableCell(withIdentifier: "header") as! MMTableViewHeader
        view.rightSideButtonAction = { button in
            self.performSegue(withIdentifier: self.CategorySegue, sender: nil)
        }
        return view
    }

}
