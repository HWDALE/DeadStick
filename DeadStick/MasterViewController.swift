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
    var selectedItem = IndexPath(row: 0, section: 0)
    
    // Declare empty array and assign to variable.
    var deadsticks = [DeadStick]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use edit button provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as?  DetailViewController
        }
        
        // Select source of data and load.
        if let savedDeadSticks = DeadStick.loadDeadSticks() {
            deadsticks = savedDeadSticks
        } else {
            deadsticks = DeadStick.loadSampleDeadSticks()
        }
    }
    
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View data source.
    // Add number of sections.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Add number of rows.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deadsticks.count
    }
    
    // Table view cells are reused and should be dequeued using cell identifier.
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
    
    // Override to support conditional editing of table view.
    override func tableView(_ tableView: UITableView, canEditRowAt
        indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = indexPath
        print(selectedItem.row)
    }
    
    // Mark: Master table view navigation.
    // Segue to detail view controller and pass data.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "addDetail":
            if let index = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: index, animated: true)
            }
            detailViewController?.previousSelectionPath = selectedItem
            
            os_log("Adding New Aircraft.", log: OSLog.default, type: .debug)
        
        case "showDetail":
            let detailViewController = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedDeadStick = deadsticks[indexPath.row]
            detailViewController.deadstick = selectedDeadStick
            detailViewController.navigationItem.leftBarButtonItem = nil
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    // MARK: Actions
    // Unwind segue from detail view controller.
    @IBAction func unwindAircraftData(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else {
            tableView.selectRow(at: selectedItem, animated: true, scrollPosition: .none)
            return }
        let sourceViewController = segue.source as!
        DetailViewController
        
        // Edited data passed from Detail View Controller.
        if let deadstick = sourceViewController.deadstick {
            if let selectedIndexPath =
                tableView.indexPathForSelectedRow {
                deadsticks[selectedIndexPath.row] = deadstick
                tableView.reloadRows(at: [selectedIndexPath],
                                     with: .none)
                tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .none)
                DeadStick.saveDeadSticks(deadsticks)
                
                // New data passed from detail view controller.
            } else {
                let newIndexPath = IndexPath(row: deadsticks.count,
                                             section: 0)
                deadsticks.append(deadstick)
                tableView.insertRows(at: [newIndexPath],
                                     with: .automatic)
                DeadStick.saveDeadSticks(deadsticks)
                tableView.selectRow(at: newIndexPath, animated: true, scrollPosition: .none)
            }
        }
    }
    // End class definition.
}

