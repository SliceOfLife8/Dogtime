//
//  FavoriteEntity+Extension.swift
//  dogtime
//
//  Created by Chris Petimezas on 14/10/23.
//

import CoreData

extension FavoriteEntity {

    /// Converting from `Persistence to Domain Model`.
    ///
    /// - Returns: The converted data model instance.
    func toModel() -> BreedImage? {
        guard let url, let breed else { return nil }
        return BreedImage(url: url, isFavorite: true, breed: breed)
    }
}
