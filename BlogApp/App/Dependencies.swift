//
//  Dependencies.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 18.02.2026.
//

import ComposableArchitecture
import Foundation
import ComposableArchitecture

extension DependencyValues {
    var apiProvider: ApiProvider {
        get { self[ApiProviderKey.self] }
        set { self[ApiProviderKey.self] = newValue }
    }
    
    var apiPostsProvider: ApiPostsProvider {
        get { self[ApiPostsProviderKey.self] }
        set { self[ApiPostsProviderKey.self] = newValue }
    }
}

private enum ApiProviderKey: DependencyKey {
    static let liveValue: ApiProvider = DefaultApiProvider(
        config: DefaultConfig(),
        authProvider: DefaultAuthProvider(
            sessionKeeper: DefaultSessionKeeper()
        )
    )
}

private enum ApiPostsProviderKey: DependencyKey {
    static let liveValue: ApiPostsProvider = {
        @Dependency(\.apiProvider) var apiProvider
        return DefaultApiPostsProvider(apiProvider: apiProvider)
    }()
}
