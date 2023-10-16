//
//  CoreDataStack.swift
//  dogtime
//
//  Created by Chris Petimezas on 14/10/23.
//

import CoreData

/// A class responsible for `NSManagedObjectContext`
class CoreDataStack {

    // MARK: - Properties

    /// Creates and configures a private queue context.
    lazy var managedContext: NSManagedObjectContext = {
        let taskContext = Self.storeContainer.viewContext
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }()

    private static var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BreedModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // MARK: - Methods

    func saveContext() {
        managedContext.saveToPersistentStore()
    }
}
