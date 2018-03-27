//
//  MasterViewController.swift
//  DeadStick
//
//  Created by Hal W. Dale, Jr. on 11/17/17.
//  Copyright © 2017 Hal W. Dale, Jr. All rights reserved.
//

import UIKit
import os.log

// Define class.
class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Split View Controller setup.
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
 
        // Select source of data and load.
        if let savedDeadSticks = DeadStick.loadDeadSticks() {
            deadsticks = savedDeadSticks
        } else {
            deadsticks = DeadStick.loadSampleDeadSticks()
        }
    }

    // Unwind segue from detail view controller.
    @IBAction func unwindShowDetailSegue(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as!
        DetailViewController
        
        // Edited data passed from Detail View Controller.
        if let deadstick = sourceViewController.deadstick {
            if let selectedIndexPath =
                tableView.indexPathForSelectedRow {
                deadsticks[selectedIndexPath.row] = deadstick
                tableView.reloadRows(at: [selectedIndexPath],
                                     with: .none)
                DeadStick.saveDeadSticks(deadsticks)
                
        // New data passed from detail view controller.
            } else {
                let newIndexPath = IndexPath(row: deadsticks.count,
                section: 0)
                deadsticks.append(deadstick)
                tableView.insertRows(at: [newIndexPath],
                                 with: .automatic)
                DeadStick.saveDeadSticks(deadsticks)
            }
        }
    }
    
    // Declare empty array and assign to variable.
    var deadsticks = [DeadStick]()
    
    // Clear selection.
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Master Table View data functions.
    // Add number of rows.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deadsticks.count
    }
    
    // Report error if problem with cell.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else
        {
            fatalError("Could not degueue a cell")
        }
        // Place text in cell
        let deadstick = deadsticks[indexPath.row]
        cell.textLabel?.text = deadstick.aircraft
        return cell
    }
    
    // Function to edit row in table
    override func tableView(_ tableView: UITableView, canEditRowAt
        indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Function to delete row in table
    override func tableView(_ tableView: UITableView, commit
        editingStyle: UITableViewCellEditingStyle, forRowAt indexPath:
        IndexPath) {
        if editingStyle == .delete {
            deadsticks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            // Array.function(data).
            DeadStick.saveDeadSticks(deadsticks)
        }
    }
    
    // Mark: Master table view navigation.
    // Segue to detail view controller and pass data.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
            
        case "addDetail":
            os_log("Adding New Aircraft.", log: OSLog.default, type: .debug)
            
        case "showDetail":
            if let indexPath = tableView.indexPathForSelectedRow {
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            let selectedDeadStick = deadsticks[indexPath.row]
            controller.deadstick = selectedDeadStick
            }
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    // End class definition.
}

