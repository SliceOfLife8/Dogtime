//
//  InjectIdentifier.swift
//  dogtime
//
//  Created by Chris Petimezas on 17/11/23.
//

import Foundation

struct InjectIdentifier<T> {

    private(set) var type: T.Type

    init(_ type: T.Type) {
        self.type = type
    }
}

extension InjectIdentifier: Hashable {

    static func == (lhs: InjectIdentifier, rhs: InjectIdentifier) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
    }
}
