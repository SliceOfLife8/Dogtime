//
//  BreedRouter.swift
//  dogtime
//
//  Created by Chris Petimezas on 14/10/23.
//

import Foundation

enum BreedRouter: NetworkTarget {
    case getAllBreeds
    case getBreedImagesBy(_ breed: String)

    var baseURL: URL { URL(string: "https://dog.ceo/api/")! }

    var path: String {
        switch self {
        case .getAllBreeds:
            return "breeds/list/all"
        case .getBreedImagesBy(let breed):
            return "breed/\(breed)/images"
        }
    }
}
