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

	// This is a closure
	lazy var fetchResultsController: NSFetchedResultsController<Task> = { // making this lazy give us access to things that are outside of the closure. In this case the count.

		let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest() // This gets every Task in CoreData
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: true)]

		// YOU MUST make the descriptor with the same key path as the sectionNameKeyPath be the first sort descriptor in this array.

		let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
											 managedObjectContext: CoreDataStack.shared.mainContext,
											 sectionNameKeyPath: "priority",
											 cacheName: nil)

		frc.delegate = self

		do {
			try frc.performFetch()
		} catch {
			fatalError("Error performing fetch for frc: \(error)")
		}
		return frc
	}()

	// NOTE! This is not a good, efficient way to do this, as the fetch request
	// will be executed every time the tasks property is accessed. We will
	// learn a better way to do this later.
//	var tasks: [Task] {
//		let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
//
//		do {
//			let tasks = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
//			return tasks
//		} catch {
//			NSLog("Error fetching tasks: \(error)")
//			return []
//		}
//	}

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
        return fetchResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)

		let task = fetchResultsController.object(at: indexPath)

        cell.textLabel?.text = task.name

        return cell
    }

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

		guard let sectionInfo = fetchResultsController.sections?[section] else { return nil }

		return sectionInfo.name.capitalized
	}



    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

			let task = fetchResultsController.object(at: indexPath)

			taskController.deleteTask(task: task)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowTaskDetail" {
			guard let detailVC = segue.destination as? TaskDetailViewController,
				let indexPath = tableView.indexPathForSelectedRow else { return }

			let task = fetchResultsController.object(at: indexPath)

			detailVC.task = task
			detailVC.taskController = taskController
		} else if segue.identifier == "ShowCreateTask" {
			guard let detailVC = segue.destination as? TaskDetailViewController else { return }

			detailVC.taskController = taskController
		}
    }
}

extension TasksTableViewController: NSFetchedResultsControllerDelegate {

	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
					didChange anObject: Any,
					at indexPath: IndexPath?,
					for type: NSFetchedResultsChangeType,
					newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			guard let newIndexPath = newIndexPath else { return }
			tableView.insertRows(at: [newIndexPath], with: .automatic)
		case .delete:
			guard let indexPath = indexPath else { return }
			tableView.deleteRows(at: [indexPath], with: .automatic)
		case .move:
			guard let indexPath = indexPath,
				let newIndexPath = newIndexPath else { return }
			tableView.moveRow(at: indexPath, to: newIndexPath)
		case .update:
			guard let indexPath = indexPath else { return }
			tableView.reloadRows(at: [indexPath], with: .automatic)
		@unknown default:
			return
		}
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
					didChange sectionInfo: NSFetchedResultsSectionInfo,
					atSectionIndex sectionIndex: Int,
					for type: NSFetchedResultsChangeType) {

		let sectionSet = IndexSet(integer: sectionIndex)

		switch type {
		case .insert:
			tableView.insertSections(sectionSet, with: .automatic)
		case .delete:
			tableView.deleteSections(sectionSet, with: .automatic)
		default:
			return
		}
	}
}
