//
//  ViewController.swift
//  ToDoApp
//
//  Created by Jack Adams on 29/06/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import UIKit

class TasksTableViewController: UIViewController {
   
    let initialTodoLoadingGroup = DispatchGroup()
    lazy var todoModelController: ToDoModelController = ToDoModelController(group: initialTodoLoadingGroup)
    var categoryModelController: CategoryModelController!
    
    var displaying: TaskDisplay!
   
    var tableViewDataSource: ToDoTableViewDataSource?
    var tableViewDelegate: ToDoTableViewDelegate?
    
    let selectSegueIdetifier = "showTask"
    let addTodoSegueIdentifier =  "addToDo"
    
    var selectedTaskIndex: Int? {
        didSet {
            if selectedTaskIndex != nil {
                performSegue(withIdentifier: selectSegueIdetifier, sender: nil)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loadingView = UIActivityIndicatorView()
        setup(LoadingView: loadingView)
        
        switch displaying! {
        case .allTodos:
            navigationItem.title = "All Todos"
        case .category(let category):
            navigationItem.title = category.name
        }
        
        
        
        tableViewDelegate = ToDoTableViewDelegate(tableView: toDoTableView, toDoModelController: todoModelController, vc: self)
        
        tableViewDataSource = ToDoTableViewDataSource(tableview: toDoTableView, toDoModelController: todoModelController, categoryModelController: categoryModelController, displaying: displaying)
        
        initialTodoLoadingGroup.notify(queue: .main) {
            loadingView.stopAnimating()
            self.toDoTableView.reloadData()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        
    }
    
    
    func editModalCompletion(withChanges changed: Bool) {
        if changed {
            if let index = selectedTaskIndex {
                let path = IndexPath(row: index, section: 0)
                toDoTableView.reloadRows(at: [path], with: .fade)
                selectedTaskIndex = nil
            }
        }
    }
    
    func addTodoCompletion(withChanges changed: Bool) {
        if changed {
            toDoTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == selectSegueIdetifier {
            let viewAndEditTaskController = segue.destination as? ViewAndEditTaskViewController
            viewAndEditTaskController?.taskIndex = selectedTaskIndex
            viewAndEditTaskController?.todoModelController = todoModelController
            viewAndEditTaskController?.callback = editModalCompletion(withChanges:)
        } else if segue.identifier == addTodoSegueIdentifier {
            let addTodoController = segue.destination as? AddToDoViewController
            addTodoController?.todoModelController = todoModelController
            addTodoController?.callback = addTodoCompletion(withChanges:)
        }
    }
    
    func deleteTableViewData(atRow indexPath: IndexPath, withAnimation animation: UITableView.RowAnimation) {
        toDoTableView.deleteRows(at: [indexPath], with: animation)
    }
    
    @IBAction func pressAddTodo(_ sender: UIButton) {
    }
    
    @IBOutlet weak var toDoTableView: UITableView!
    
    func setup(LoadingView loadingView: UIActivityIndicatorView) {
        loadingView.hidesWhenStopped = true
        loadingView.center = self.view.center
        loadingView.style = .gray
        view.addSubview(loadingView)
        loadingView.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    
}

