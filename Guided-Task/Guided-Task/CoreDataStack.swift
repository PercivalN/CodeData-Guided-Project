//
//  CoreDataStack.swift
//  Guided-Task
//
//  Created by Percy Ngan on 9/22/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import Foundation
import CoreData

// This file creates the whole NSPersistenContainer functionality, which includes the NSManagedObjectContext (moc), NSPersistent Store Coordinator, and NSPersistent Store.

class CoreDataStack {

	//  Lazy means that the compiler will not initialize the container when the CoreDataStack is initialized, only when the container variable is called.
	lazy var container: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Tasks")
		// This loads the persistent store
		// MARK: - Questions: Whats the underscore before the error for?
		container.loadPersistentStores(completionHandler: { (_, error) in
			if let error = error {
				fatalError("Failed to load persistent stores: \(error)")
			}
		})
		return container
	}()

	var mainContext: NSManagedObjectContext {
		return container.viewContext
	}
}
