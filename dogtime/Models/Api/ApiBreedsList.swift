//
//  ApiBreedsList.swift
//  dogtime
//
//  Created by Chris Petimezas on 14/10/23.
//

import Foundation

struct ApiBreedsList: Decodable {
    let message: [String: [String]]
    let status: String
}
