//
//  Container.swift
//  dogtime
//
//  Created by Chris Petimezas on 17/11/23.
//

import Foundation

/// DI Container is a framework for implementing automatic dependency injection.
/// It manages object creation and it's life-time, and also injects dependencies to the class.
/// The container creates an object of the specified class and also injects all the dependency objects through
/// a constructor, a property or a method at run time and disposes it at the appropriate time.
/// This is done so that we don't have to create and manage objects manually.
class DIContainer: Injectable {

    static let shared = DIContainer()

    var dependencies: [AnyHashable: Any] = [:]
}
