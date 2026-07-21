//
//  Dependencies.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 30.03.2026.
//

import Foundation
import AuthSDK
import Core
import SwiftUI
import Combine

struct AppServices {
    let config: ConfigProtocol
    let sessionProvider: SessionProviderProtocol
    let apiProvider: ApiProvider
    let authProvider: AuthProviderProtocol
    let apiPostsProvider: ApiPostsProvider
    let registrationViewModel: RegistrationViewModel
    let postsFeedViewModel: PostsFeedViewModel
    
    init() {
        self.config = DefaultConfig()
        self.sessionProvider = AuthAssembly.buildSessionProvider()
        self.apiProvider = DefaultApiProvider(config: config, sessionProvider: sessionProvider)
        self.authProvider = DefaultAuthProvider(apiProvider: apiProvider, sessionProvider: sessionProvider)
        self.apiPostsProvider = DefaultApiPostsProvider(apiProvider: apiProvider)
        self.registrationViewModel = RegistrationViewModel(authProvider: authProvider)
        self.postsFeedViewModel = PostsFeedViewModel(apiPostsProvider: apiPostsProvider)
    }
}

private struct ConfigKey: EnvironmentKey {
    static let defaultValue: ConfigProtocol = DefaultConfig()
}

private struct SessionProviderKey: EnvironmentKey {
    static let defaultValue: SessionProviderProtocol = AuthAssembly.buildSessionProvider()
}

private struct ApiProviderKey: EnvironmentKey {
    static let defaultValue: ApiProvider = DefaultApiProvider(config: DefaultConfig(), sessionProvider: AuthAssembly.buildSessionProvider())
}

private struct AuthProviderKey: EnvironmentKey {
    static let defaultValue: AuthProviderProtocol = DefaultAuthProvider(
        apiProvider: DefaultApiProvider(
            config: DefaultConfig(),
            sessionProvider: AuthAssembly.buildSessionProvider()
        ), sessionProvider: AuthAssembly.buildSessionProvider()
    )
}

private struct ApiPostsProviderKey: EnvironmentKey {
    static let defaultValue: ApiPostsProvider = DefaultApiPostsProvider(apiProvider: DefaultApiProvider(config: DefaultConfig(), sessionProvider: AuthAssembly.buildSessionProvider()))
}

extension EnvironmentValues {
    var config: ConfigProtocol {
        get { self[ConfigKey.self] }
        set { self[ConfigKey.self] = newValue }
    }
    
    var sessionProvider: SessionProviderProtocol {
        get { self[SessionProviderKey.self] }
        set { self[SessionProviderKey.self] = newValue }
    }
    
    var apiProvider: ApiProvider {
        get { self[ApiProviderKey.self] }
        set { self[ApiProviderKey.self] = newValue }
    }
    
    var authProvider: AuthProviderProtocol {
        get { self[AuthProviderKey.self] }
        set { self[AuthProviderKey.self] = newValue }
    }
    
    var apiPostsProvider: ApiPostsProvider {
        get { self[ApiPostsProviderKey.self] }
        set { self[ApiPostsProviderKey.self] = newValue }
    }
}

//final class AppDIContainer: DIContainer {
//    
//    override func setup() {
//        // Register shared services
//        registerShared(ConfigProtocol.self) { _ in
//            DefaultConfig()
//        }
//
//        registerShared(SessionProviderProtocol.self) { _ in
//            AuthAssembly.buildSessionProvider()
//        }
//        
//        register(ApiProvider.self) { container in
//            DefaultApiProvider(
//                config: container.resolve(),
//                sessionProvider: container.resolve()
//            )
//        }
//        
//        register(AuthProviderProtocol.self) { container in
//            DefaultAuthProvider(apiProvider: container.resolve())
//        }
//        
//        register(RegistrationViewModel.self) { container in
//            RegistrationViewModel(authProvider: container.resolve())
//        }
//        
//        register(ApiPostsProvider.self) { container in
//            DefaultApiPostsProvider(apiProvider: container.resolve())
//        }
//        
//        register(PostsFeedViewModel.self) { container in
//            PostsFeedViewModel(apiPostsProvider: container.resolve())
//        }
//        
//        // Register view models that need arguments
//        register(PostDetailViewModel.self) { container, postID in
//            PostDetailViewModel(
//                postID: postID,
//                apiPostsProvider: container.resolve()
//            )
//        }
//    }
//}
