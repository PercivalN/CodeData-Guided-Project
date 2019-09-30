//
//  TaskController.swift
//  Guided-Task
//
//  Created by Percy Ngan on 9/28/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import Foundation
import CoreData

class TaskController {

	@discardableResult func createTask(with name: String, notes: String?) -> Task {

		let task = Task(name: name, notes: notes, context: CoreDataStack.shared.mainContext)

		CoreDataStack.shared.saveToPersistentStore()

		return task
	}

	func updateTask(task: Task, with name: String, notes: String?) {

		task.name = name
		task.notes = notes

		CoreDataStack.shared.saveToPersistentStore() // After you change the name and notes of the task, they are only in memory, which is why we have to save them to the Persistent Store.
	}

	func deleteTask(task: Task) {

		CoreDataStack.shared.mainContext.delete(task) // This deletes the task from the mainContext.
		CoreDataStack.shared.saveToPersistentStore() // This syncs up whatever is in the mainContext and ups it in the Persistent Store and because there is nothing in the mainContext, then the persistent Store will also sync up with that and contain nothing.
	}
}
