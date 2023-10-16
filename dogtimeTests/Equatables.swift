//
//  Equatables.swift
//  dogtimeTests
//
//  Created by Chris Petimezas on 16/10/23.
//

@testable import dogtime

extension ApiBreedsList: Equatable {
    public static func == (lhs: ApiBreedsList, rhs: ApiBreedsList) -> Bool {
        lhs.message == rhs.message
    }
}

extension ApiBreedImages: Equatable {
    public static func == (lhs: ApiBreedImages, rhs: ApiBreedImages) -> Bool {
        return lhs.message == rhs.message
    }
}
