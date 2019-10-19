//
//  ViewController.swift
//  ToDoApp
//
//  Created by Jack Adams on 29/06/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import UIKit

class TasksTableViewController: UIViewController {
    
    let taskSegueIdentifier =  "addToDo"
   
    private var taskViewModels = [TaskViewModel]()
    
    var displaying: TaskDisplay!
    
    var selectedTaskIndex: Int? {
        didSet {
            if let index = selectedTaskIndex {
                performSegue(withIdentifier: taskSegueIdentifier, sender: taskViewModels[index])
            }
        }
    }
    
    @IBOutlet weak var toDoTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupNavBar()
        
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == taskSegueIdentifier {
            if let task = sender as? TaskViewModel {
                prepareForEdit(segue: segue, withTask: task)
            } else {
                prepareForAddTodo(segue: segue)
            }
        }
    }
    
    private func prepareForAddTodo(segue: UIStoryboardSegue) {
        let addTodoController = segue.destination as? TaskViewController
        addTodoController?.callback = { changed in
            if changed {
                self.toDoTableView.performBatchUpdates({
                    self.toDoTableView.reloadSections(IndexSet(integer: 0), with: .fade)
                }, completion: nil)
            }
        }
        addTodoController?.function = .add
    }
    
    private func prepareForEdit(segue: UIStoryboardSegue, withTask task: TaskViewModel) {
        let editTaskController = segue.destination as? TaskViewController
        editTaskController?.callback = { changed in
            if let index = self.selectedTaskIndex {
                let path = IndexPath(row: index, section: 0)
                self.toDoTableView.reloadRows(at: [path], with: .fade)
                self.selectedTaskIndex = nil
            }
        }
        editTaskController?.function = .edit(viewModel: task)
        
        
    }
    
    private func setupNavBar() {
        switch displaying! {
        case .allTodos:
            navigationItem.title = "All Todos"
        case .category(let categoryViewModel):
            navigationItem.title = categoryViewModel.name
        }
    }
    
    private func createCorrectFilter() -> ((Todo) -> Bool)? {
        var filter: ((Todo) -> Bool)?
        switch displaying! {
        case .allTodos:
            filter = nil
        case .category(let categoryViewModel):
            filter = categoryViewModel.taskFilter
        }
        return filter
    }
    
    
}

extension TasksTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.taskViewModels = ToDoModelController.shared.getAllTaskViewModels(applyingFilter: createCorrectFilter(), forDisplayingOnMenu: true)
        return taskViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TaskTableViewCell
        let taskViewModel = taskViewModels[indexPath.row]
        cell.taskViewModel = taskViewModel
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTaskIndex = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return TaskTableView.taskCompleteSwipe(forTask: taskViewModels[indexPath.row], onTableView: tableView, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return TaskTableView.taskDeleteSwipe(forTask: taskViewModels[indexPath.row], onTableView: tableView, forRowAt: indexPath)
    }
}

