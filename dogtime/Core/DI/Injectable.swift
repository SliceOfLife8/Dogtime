//
//  Injectable.swift
//  dogtime
//
//  Created by Chris Petimezas on 17/11/23.
//

protocol Injectable: Resolvable, AnyObject {

    var dependencies: [AnyHashable: Any] { get set }

    func register<Value>(type: Value.Type, _ resolve: (Resolvable) throws -> Value)
}

extension Injectable {

    func register<Value>(type: Value.Type, _ resolve: (Resolvable) throws -> Value) {

        do {
            self.dependencies[InjectIdentifier(type)] = try resolve(self)
        }
        catch {
            assertionFailure(error.localizedDescription)
        }
    }

    func resolve<Value>(type: Value.Type) throws -> Value {

        guard let dependency = dependencies[InjectIdentifier(type)] as? Value else {

            throw ResolvableError.dependencyNotFound(type)
        }

        return dependency
    }
}
