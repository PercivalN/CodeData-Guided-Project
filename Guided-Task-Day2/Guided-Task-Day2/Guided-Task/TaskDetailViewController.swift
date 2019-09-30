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
	@IBOutlet weak var notesTextField: UITextField!

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

		if let task = task {
			taskController?.updateTask(task: task, with: name, notes: notes)
		} else {
			taskController?.createTask(with: name, notes: notes)
		}

		navigationController?.popViewController(animated: true)
	}

	func updateViews() {

		title = task?.name ?? "Create Task"

		nameTextField.text = task?.name
		notesTextField.text = task?.notes

	}

}
