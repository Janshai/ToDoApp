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
    lazy var model: ToDoModelController = ToDoModelController(group: initialTodoLoadingGroup)
   
    var tableViewDataSource: ToDoTableViewDataSource?
    var tableViewDelegate: ToDoTableViewDelegate?
    
    let selectSegueIdetifier = "showTask"
    
    var selectedTask: (task: Todo?, path: IndexPath?) = (nil, nil) {
        didSet {
            if selectedTask.task != nil {
                performSegue(withIdentifier: selectSegueIdetifier, sender: nil)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loadingView = UIActivityIndicatorView()
        setup(LoadingView: loadingView)
        
        
        tableViewDelegate = ToDoTableViewDelegate(tableView: toDoTableView, toDoModelController: model, vc: self)
        
        tableViewDataSource = ToDoTableViewDataSource(tableview: toDoTableView, toDoModelController: model)
        
        initialTodoLoadingGroup.notify(queue: .main) {
            loadingView.stopAnimating()
            self.toDoTableView.reloadData()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == selectSegueIdetifier {
            let viewAndEditTaskController = segue.destination as? ViewAndEditTaskViewController
            viewAndEditTaskController?.todo = selectedTask.task
        }
    }
    
    func addNewTask(withTitle title: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            //TODO: pop up an error message if the todo doesn't add correctly and handle that.
            self.model.addTodo(withTitle: title)
            DispatchQueue.main.async {
                self.toDoTableView.reloadData()
            }
        }
        
    }
    
    func editTask(withId id: String, toNowEqual todo: Todo) {
        model.editTodo(withIdentifier: id, toNowEqual: todo)
        if let path = selectedTask.path {
            toDoTableView.reloadRows(at: [path], with: .fade)
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

