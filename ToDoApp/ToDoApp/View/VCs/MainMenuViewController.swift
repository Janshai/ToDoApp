//
//  MainMenuViewController.swift
//  ToDoApp
//
//  Created by Jack Adams on 19/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    // MARK: Segue Identifiers
    private let todoScreenSegue = "TodoScreen"
    private let CategorySegue = "Category"
    
    //MARK: Category Model related properties
    private var categoryModelController = CategoryModelController()
    private var categoryViewModels = [CategoryViewModel]()
    
    //MARK: Outlets
    /// Outlet for Main TableView
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK VC Lifecycle Functions
    /// Override of ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryViewModels = categoryModelController.getAllCategoryViewModels(forDisplayingOnMenu: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MMTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: MMTableViewHeader.reuseIdentifier)
        
        
    }
    
    
    /// Override of Preparation for Segues function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == todoScreenSegue, let display = sender as? TaskDisplay, let todoVC = segue.destination as? TasksTableViewController {
            // segue to Tasks screen
            todoVC.displaying = display
            todoVC.categoryModelController = self.categoryModelController
        } else if segue.identifier == CategorySegue, let vc = segue.destination as? CategoryViewController {
            // segue to add a new category or edit an existing category
            if let index = sender as? IndexPath {
                vc.function = .edit
                vc.categoryViewModel = categoryViewModels[index.row]
                vc.completion = {
                    self.tableView.reloadRows(at: [index], with: .fade)
                }
            } else {
                vc.function = .add
            }
        }
    }

}

extension MainMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: TableView Data Source Functions
    
    /// Number of Sections in the TableView
    /// Should be 2
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /// Number of rows in each section
    /// - First Section has one row for segueing to display all todos
    /// - Second Section has as many rows as there are Categories
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
    
    
    /// Cell For Row In Section
    /// - Section 1 has 1 cell for displaying all todos
    /// - Section 2 cells describe the categories of tasks. Setup can be seen in TaskTableView.swift
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TaskTableViewCell
        
        switch indexPath.section {
        case 0:
            cell.taskTitleLabel.text = "All Todos"
            cell.emojiLabel.text = "📝"
        case 1:
            let categoryViewModel = categoryViewModels[indexPath.row]
            cell.categoryViewModel = categoryViewModel
            
        default:
            return cell
        }
        
        return cell
    }
    
    // MARK: TableView Delegate Functions
    
    /// Behaviour for selecting cells
    /// All cells segue to the tasks screen in TasksTableViewController.swift and Main.storyboard.
    /// The categories cells filter the tasks displayed on the next screen to just tasks in the selected category
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var displayType: TaskDisplay
        switch indexPath.section {
        case 1:
            let categoryViewModel = categoryModelController.getCategoryViewModel(atIndex: indexPath.row)
            displayType = .category(categoryViewModel)
        default:
            displayType = .allTodos
        }
        
        performSegue(withIdentifier: todoScreenSegue, sender: displayType)
        
    }
    
    
    /// Swiping Right on a Category presents an option to delete it. Setup of this is in TasksTableView.swift
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        switch indexPath.section {
        case 1:
            return TaskTableView.categoryDeleteSwipe(forTableView: tableView, forRowAt: indexPath)
        default:
            return nil
        }
        
    }
    
    /// Swiping Left on a Category presents an option to edit it. Setup of this is in TasksTableView.swift
    /// If the user edits the category, we segue to the Category Screen in CategoryViewController.swift and Category.storyboard
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        switch indexPath.section {
        case 1:
            return TaskTableView.categoryEditSwipe(forTableView: tableView, forRowAt: indexPath) { category in
                
                self.performSegue(withIdentifier: self.CategorySegue, sender: indexPath)
            }
        default:
            return UISwipeActionsConfiguration(actions: [])
        }
    }
    
    /// Setup the headers for the TableView
    /// First Section has no header
    /// Second Section Header is created in setupHeader(forTableView:)
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            return setupCategoriesHeader(forTableView: tableView)
        default:
            return nil
        }
        
    }
    
    /// Header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    /// Header for categories section
    /// Has a + button that when pressed causes a segue to the Add Category screen described in CategoryViewController.swift and Category.storyboard
    private func setupCategoriesHeader(forTableView tableView: UITableView) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: MMTableViewHeader.reuseIdentifier) as! MMTableViewHeader
        view.rightSideButtonAction = { button in
            self.performSegue(withIdentifier: self.CategorySegue, sender: nil)
        }
        view.frame.size.height = 50
        return view
    }

}
