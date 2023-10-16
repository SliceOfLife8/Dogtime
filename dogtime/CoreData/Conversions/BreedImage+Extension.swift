//
//  BreedImage+Extension.swift
//  dogtime
//
//  Created by Chris Petimezas on 14/10/23.
//

import CoreData

extension BreedImage {

    /// Converting from `Domain To Persistence Model`.
    ///
    /// - Parameter context: The managed object context to use.
    /// - Returns: The converted managed object instance.
    func toManagedObject(in context: NSManagedObjectContext) -> FavoriteEntity {
        let object = FavoriteEntity(context: context)
        object.id = identifier
        object.url = url
        object.breed = breed
        return object
    }
}
