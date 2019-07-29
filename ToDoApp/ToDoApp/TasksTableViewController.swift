//
//  ViewController.swift
//  ToDoApp
//
//  Created by Jack Adams on 29/06/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import UIKit

class TasksTableViewController: UIViewController {
    
    let model = ToDoModelController()
    var tableViewDataSource: ToDoTableViewDataSource?
    var tableViewDelegate: ToDoTableViewDelegate?
    let selectSegueIdetifier = "showTask"
    var selectedTask: Todo? = nil {
        didSet {
            if selectedTask != nil {
                performSegue(withIdentifier: selectSegueIdetifier, sender: nil)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableViewDelegate = ToDoTableViewDelegate(tableView: toDoTableView, toDoModelController: model, vc: self)
        
        tableViewDataSource = ToDoTableViewDataSource(tableview: toDoTableView, toDoModelController: model)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == selectSegueIdetifier {
            let viewAndEditTaskController = segue.destination as? ViewAndEditTaskViewController
            viewAndEditTaskController?.todo = selectedTask
        }
    }
    
    func addNewTask(withTitle title: String) {
        model.addTodo(withTitle: title)
        toDoTableView.reloadData()
    }
    
    func editTask(withId id: UUID, toNowEqual todo: Todo) {
        model.editTodo(withIdentifier: id, toNowEqual: todo)
        toDoTableView.reloadData()
    }
    
    @IBAction func pressAddTodo(_ sender: UIButton) {
    }
    
    @IBOutlet weak var toDoTableView: UITableView!
    
    
}

