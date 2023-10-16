//
//  Extension+NSManagedObjectContext.swift
//  dogtime
//
//  Created by Chris Petimezas on 14/10/23.
//

import CoreData

extension NSManagedObjectContext {

    func saveToPersistentStore() {
        performAndWait {
            guard self.hasChanges else { return }

            do {
                try self.save()
            }
            catch let error as NSError {
                debugPrint("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    func execute<ResultType: NSManagedObject>(
        fetchRequest: NSFetchRequest<ResultType>
    ) throws -> [ResultType] {
        var result: Result<[ResultType], Error> = .success([])

        performAndWait {
            do {
                try result = .success(fetch(fetchRequest))
            }
            catch {
                result = .failure(error)
            }
        }

        return try result.get()
    }

    func insertRecord<T: NSManagedObject>(_ object: T) {
        performAndWait {
            insert(object)
            saveToPersistentStore()
        }
    }

    func deleteRecord<T: NSManagedObject>(_ object: T) {
        performAndWait {
            delete(object)
            saveToPersistentStore()
        }
    }
}
