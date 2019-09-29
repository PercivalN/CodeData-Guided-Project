//
//  TasksTableViewController.swift
//  Guided-Task
//
//  Created by Percy Ngan on 9/28/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import UIKit
import CoreData

class TasksTableViewController: UITableViewController {

	let taskController = TaskController()

	var tasks: [Task] {
		let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()

		do {
			let tasks = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
			return tasks
		} catch {
			NSLog("Error fetching tasks: \(error)")
			return []
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)

        cell.textLabel?.text = tasks[indexPath.row].name

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
			let task = tasks[indexPath.row]

			// Always delete the model object before you delete the row.

			taskController.deleteTask(task: task)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowTaskDetail" {
			guard let detailVC = segue.destination as? TaskDetailViewController,
				let indexPath = tableView.indexPathForSelectedRow else { return }

			detailVC.task = tasks[indexPath.row]
			detailVC.taskController = taskController
		} else if segue.identifier == "ShowCreateTask" {
			guard let detailVC = segue.destination as? TaskDetailViewController else { return }

			detailVC.taskController = taskController
		}
    }
}
