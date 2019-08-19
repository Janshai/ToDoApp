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
    lazy var categoryModelController = CategoryModelController()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableviewDataSource = MMTableViewDataSource()
        
        tableView.delegate = self
        tableView.dataSource = tableviewDataSource
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == todoScreenSegue, let display = sender as? String, let todoVC = segue.destination as? TasksTableViewController {
            todoVC.displaying = display
            todoVC.categoryModelController = self.categoryModelController
        }
    }

}

extension MainMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: todoScreenSegue, sender: "AllTodos")
    }
}
