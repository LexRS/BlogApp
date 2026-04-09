//
//  DIContainer.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 02.04.2026.
//

import Foundation

struct DIKey<T> {
    var key: ObjectIdentifier {
        ObjectIdentifier(T.self)
    }
    
    var value: T
}

protocol DIContainerProtocol {
    func resolve<T>() -> T
    func resolve<T, A>(argument: A) -> T
}

class DIContainer: DIContainerProtocol {
    private let sharedInstances: [ObjectIdentifier: Any]
    private var factories: [ObjectIdentifier: (DIContainer) -> Any]
    private var argumentFactories: [ObjectIdentifier: (DIContainer, Any) -> Any]
    
    init() {
        self.sharedInstances = [:]
        self.factories = [:]
        self.argumentFactories = [:]
        setup()
    }
    
    func setup() {
        // Override in subclass or configure externally
    }
    
    func resolve<T>() -> T {
        let key = DIKey(value: T.self).key
        
        if let instance = sharedInstances[key] as? T {
            return instance
        }
        
        guard let factory = factories[key] else {
            fatalError("DI Error: No factory registered for type \(T.self)")
        }
        
        return factory(self) as! T
    }
    
    func resolve<T, A>(argument: A) -> T {
        let key = DIKey(value: T.self).key
        
        guard let factory = argumentFactories[key] else {
            fatalError("DI Error: No argument factory registered for type \(T.self)")
        }
        
        return factory(self, argument) as! T
    }
    
    func register<T>(_ type: T.Type, _ factory: @escaping (DIContainer) -> T) {
        let key = DIKey(value: type).key
        //let key = String(describing: type)
        factories[key] = factory
    }
    
    func register<T, A>(_ type: T.Type, _ factory: @escaping (DIContainer, A) -> T) {
        let key = DIKey(value: T.self).key
        argumentFactories[key] = { (container, arg) in
            guard let argumentA = arg as? A else {
                let expected = String(describing: A.self)
                let actual = String(describing: Swift.type(of: arg))
                fatalError("DI error: Expected argument of type \(expected), but got \(actual)")
            }
            return factory(container, argumentA)
        }
    }
    
    func registerShared<T>(_ type: T.Type, _ factory: @escaping (DIContainer) -> T) {
        let key = DIKey(value: T.self).key
        factories[key] = { container in
            let instance = factory(container)
            var instances = self.sharedInstances
            instances[key] = instance
            // In a real implementation, you'd need to update sharedInstances
            return instance
        }
    }
}
