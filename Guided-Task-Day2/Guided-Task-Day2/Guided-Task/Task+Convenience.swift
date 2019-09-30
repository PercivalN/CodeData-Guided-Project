//
//  Task+Convenience.swift
//  Guided-Task
//
//  Created by Percy Ngan on 9/20/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import Foundation
import CoreData

// Core data already created the Task class, so we just want to add some extra functionality onto it. You csn get ot the Task file by cmd clicking the Task.
extension Task {

	convenience init(name: String, notes: String?, context: NSManagedObjectContext) {

		// Setting up the generic NSManagedObject functionality of the modal object
		// The generic chunk of clay
		self.init(context: context)

		// Once we have the clay, we can begin sculpting it into our unique model object.
		self.name = name
		self.notes = notes
	}
}

