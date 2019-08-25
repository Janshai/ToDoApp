//
//  ViewController.swift
//  ToDoApp
//
//  Created by Jack Adams on 29/06/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import UIKit

class TasksTableViewController: UIViewController {
    
    let selectSegueIdetifier = "showTask"
    let addTodoSegueIdentifier =  "addToDo"
   
    let initialTodoLoadingGroup = DispatchGroup()
    var todoModelController: ToDoModelController!
    var categoryModelController: CategoryModelController!
    
    private var taskViewModels = [TaskViewModel]()
    
    var displaying: TaskDisplay!
    
    var selectedTaskIndex: Int? {
        didSet {
            if selectedTaskIndex != nil {
                performSegue(withIdentifier: selectSegueIdetifier, sender: nil)
            }
        }
    }
    
    @IBOutlet weak var toDoTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loadingView = UIActivityIndicatorView()
        setup(LoadingView: loadingView)
        setupNavBar()
        
        todoModelController = ToDoModelController(group: initialTodoLoadingGroup)
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
        
        initialTodoLoadingGroup.notify(queue: .main) {
            loadingView.stopAnimating()
            self.toDoTableView.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == selectSegueIdetifier {
            prepareForViewAndEdit(segue: segue)
        } else if segue.identifier == addTodoSegueIdentifier {
            prepareForAddTodo(segue: segue)
        }
    }
    
    private func prepareForAddTodo(segue: UIStoryboardSegue) {
        let addTodoController = segue.destination as? AddToDoViewController
        addTodoController?.todoModelController = todoModelController
        addTodoController?.callback = { changed in
            if changed {
                self.toDoTableView.performBatchUpdates({
                    self.toDoTableView.reloadSections(IndexSet(integer: 0), with: .fade)
                }, completion: nil)
            }
        }
        addTodoController?.categoryModelController = categoryModelController
    }
    
    private func prepareForViewAndEdit(segue: UIStoryboardSegue) {
        let viewAndEditTaskController = segue.destination as? ViewAndEditTaskViewController
        viewAndEditTaskController?.taskIndex = selectedTaskIndex
        viewAndEditTaskController?.todoModelController = todoModelController
        viewAndEditTaskController?.callback = { changed in
            if changed {
                if let index = self.selectedTaskIndex {
                    let path = IndexPath(row: index, section: 0)
                    self.toDoTableView.reloadRows(at: [path], with: .fade)
                    self.selectedTaskIndex = nil
                }
            }
        }
    }
    
    
    private func setup(LoadingView loadingView: UIActivityIndicatorView) {
        loadingView.hidesWhenStopped = true
        loadingView.center = self.view.center
        loadingView.style = .gray
        view.addSubview(loadingView)
        loadingView.startAnimating()
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
        self.taskViewModels = todoModelController.getAllTaskViewModels(applyingFilter: createCorrectFilter(), forDisplayingOnMenu: true)
        taskViewModels.forEach() { $0.categoryModel = self.categoryModelController }
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

