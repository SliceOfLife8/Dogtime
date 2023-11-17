//
//  BreedImage.swift
//  dogtime
//
//  Created by Chris Petimezas on 14/10/23.
//

import Foundation

struct BreedImage: Hashable {
    let url: URL
    var isFavorite: Bool
    let breed: String
    let identifier: String

    /// We are using url's lathPathComponent as a unique identifier.
    init(url: URL, isFavorite: Bool = false, breed: String) {
        self.url = url
        self.isFavorite = isFavorite
        self.breed = breed
        self.identifier = url.lastPathComponent
    }

    static func == (lhs: BreedImage, rhs: BreedImage) -> Bool {
        lhs.identifier == rhs.identifier && lhs.breed == rhs.breed && lhs.isFavorite == rhs.isFavorite
    }
}
