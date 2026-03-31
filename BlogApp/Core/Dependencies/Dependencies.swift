//
//  Dependencies.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 30.03.2026.
//

import Foundation

final class Dependencies {
    private let serviceLocator = ServiceLocator()
    
    init() {
        registerServices()
    }
    
    private func registerServices() {
        let a = A()
        serviceLocator.register {
            a
        }
        
        serviceLocator.register {
            DefaultConfig() as Config
        }
        
        serviceLocator.register {
            DefaultAuthProvider(sessionKeeper: DefaultSessionKeeper()) as AuthProvider
        }
        
        
        serviceLocator.register { [weak self] in
            guard let self else { fatalError("Dependencies deallocated")}
            return DefaultApiProvider(
                config: self.serviceLocator.resolveService() as Config,
                authProvider: self.serviceLocator.resolveService() as AuthProvider
            ) as ApiProvider
        }
        
        serviceLocator.register { [weak self] in
            guard let self else { fatalError("Dependencies deallocated") }
            return DefaultApiPostsProvider(
                apiProvider: self.serviceLocator.resolveService() as ApiProvider
            ) as ApiPostsProvider
        }
    }
    
    func getA() -> Aable {
        serviceLocator.resolveService() as Aable
    }
    
    func getPostsFeedViewModel() -> PostsFeedViewModel {
        let postsProvider = serviceLocator.resolveService() as ApiPostsProvider
        return PostsFeedViewModel(apiPostsProvider: postsProvider, coordinator: PostsFeedCoordinator())
    }
}

protocol Aable: AnyObject {
    func increment()
    func printCounter()
}

class A: Aable {
    private var counter: Int = 0
    
    func increment() {
        counter += 1
    }
    
    func printCounter() {
        print(counter)
    }
}
