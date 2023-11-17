//
//  Resolvable.swift
//  dogtime
//
//  Created by Chris Petimezas on 17/11/23.
//

import Foundation

protocol Resolvable {

    func resolve<Value>(type: Value.Type) throws -> Value
}

enum ResolvableError: Error {

    case dependencyNotFound(Any.Type)
}

extension ResolvableError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case let .dependencyNotFound(type):
            return "Could not find dependency for type: \(type)"
        }
    }
}
