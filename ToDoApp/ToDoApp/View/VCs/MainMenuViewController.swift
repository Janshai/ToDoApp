//
//  MainMenuViewController.swift
//  ToDoApp
//
//  Created by Jack Adams on 19/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    let todoScreenSegue = "TodoScreen"
    var tableviewDataSource: UITableViewDataSource?
    var tableviewDelegate: UITableViewDelegate?
    lazy var categoryModelController = CategoryModelController()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableviewDataSource = MMTableViewDataSource(tableView: tableView, categoryModelController: categoryModelController)
        tableviewDelegate = MMTableViewDelegate(tableView: tableView, categoryModelController: categoryModelController, selectRowAction: tableViewSelectBehaviour(_:display:), editBehaviour: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == todoScreenSegue, let display = sender as? TaskDisplay, let todoVC = segue.destination as? TasksTableViewController {
            todoVC.displaying = display
            todoVC.categoryModelController = self.categoryModelController
        }
    }
    
    private func tableViewSelectBehaviour(_: UITableView, display: TaskDisplay) {
        performSegue(withIdentifier: todoScreenSegue, sender: display)
    }

}
