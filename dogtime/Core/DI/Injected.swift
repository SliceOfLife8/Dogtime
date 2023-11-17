//
//  Injected.swift
//  dogtime
//
//  Created by Chris Petimezas on 17/11/23.
//

import Foundation

@propertyWrapper
struct Injected<T> {

    private let identifier: InjectIdentifier<T>
    private let container: Resolvable

    init() {
        self.identifier = InjectIdentifier(T.self)
        self.container = DIContainer.shared
    }

    lazy var wrappedValue: T = {
        do {
            return try container.resolve(type: identifier.type)
        }
        catch {
            fatalError( error.localizedDescription )
        }
    }()
}
