//
//  ServiceLocator.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 30.03.2026.
//

protocol ServiceLocating {
    func register<T>(_ service: @escaping () -> T)
    func clearServices()
    func resolveService<T>() -> T
}

final class ServiceLocator: ServiceLocating {
    private var container: [ObjectIdentifier: Any] = [:]
    
    func register<T>(_ service: @escaping () -> T) {
        container[ObjectIdentifier(T.self)] = service
    }
    
    func clearServices() {
        container.removeAll()
    }
    
    func resolveService<T>() -> T {
        guard let service = container[ObjectIdentifier(T.self)] as? () -> T else {
            preconditionFailure("Could not locate \(T.self)")
        }
        return service()
    }
}
