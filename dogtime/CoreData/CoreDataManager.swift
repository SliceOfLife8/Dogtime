//
//  CoreDataManager.swift
//  dogtime
//
//  Created by Chris Petimezas on 14/10/23.
//

import CoreData

class CoreDataManager {

    private(set) var stack: CoreDataStack

    init(stack: CoreDataStack = CoreDataStack()) {
        self.stack = stack
    }
}

extension CoreDataManager: FavoriteOperationsProtocol {
    func addNewRecord(_ breedImage: BreedImage) {
        let favoriteEntity = breedImage.toManagedObject(in: stack.managedContext)

        stack.managedContext.insertRecord(favoriteEntity)
    }

    func removeRecord(_ breedImage: BreedImage) {
        guard let entity = fetchRecord(for: breedImage.identifier) else { return }
        stack.managedContext.deleteRecord(entity)
    }

    func fetchAllRecords() -> [FavoriteEntity] {
        let fetchEntity: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()

        do {
            let entities = try stack.managedContext.execute(fetchRequest: fetchEntity)
            return entities
        }
        catch {
            return []
        }
    }

    func fetchRecord(for id: String) -> FavoriteEntity? {
        let fetchEntity: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()
        fetchEntity.predicate = NSPredicate(format: "id = %@", id)

        return try? stack.managedContext.execute(fetchRequest: fetchEntity).first
    }
}
