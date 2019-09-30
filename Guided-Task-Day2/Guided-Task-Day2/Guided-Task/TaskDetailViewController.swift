//
//  DetailViewController.swift
//  Guided-Task
//ar
//  Created by Percy Ngan on 9/28/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var notesTextField: UITextView!
	
	@IBOutlet weak var prioritySegmentedControl: UISegmentedControl!

	var taskController: TaskController?
	var task: Task?

	override func viewDidLoad() {
        super.viewDidLoad()

		updateViews()

        // Do any additional setup after loading the view.
    }

	// MARK: - Actions
	@IBAction func saveButtonTapped(_ sender: Any) {

		guard let name = nameTextField.text,
			let notes = notesTextField.text,
			!name.isEmpty else { return }

		// Using some information from the segmented control, get a TaskPriority to pass to the function below.
		let index = prioritySegmentedControl.selectedSegmentIndex

		let priority = TaskPriority.allCases[index] // this does the same as the switch statement below

//		let priority: TaskPriority

//		switch index {
//		case 0:
//			priority = .low
//		case 1:
//			priority = .normal
//		case 2:
//			priority = .high
//		case 3:
//			priority = .critical
//		default:
//			priority = .normal
//		}

		if let task = task {
			taskController?.updateTask(task: task, with: name, notes: notes, priority: priority)
		} else {
			taskController?.createTask(with: name, notes: notes, priority: priority)
		}

		navigationController?.popViewController(animated: true)
	}

	func updateViews() {

		title = task?.name ?? "Create Task"

		nameTextField.text = task?.name
		notesTextField.text = task?.notes

		if let priorityString = task?.priority,
			let priority = TaskPriority(rawValue: priorityString) {

			let index = TaskPriority.allCases.firstIndex(of: priority) ?? 0

			prioritySegmentedControl.selectedSegmentIndex = index
		}
	}
}
