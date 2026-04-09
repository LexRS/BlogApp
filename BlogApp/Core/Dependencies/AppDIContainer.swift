//
//  Dependencies.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 30.03.2026.
//

import Foundation

final class AppDIContainer: DIContainer {
    override func setup() {
        // Register shared services
        registerShared(Config.self) { _ in
            DefaultConfig()
        }
        
        registerShared(SessionKeeper.self) { _ in
            DefaultSessionKeeper()
        }
        
        register(AuthProvider.self) { container in
            DefaultAuthProvider(sessionKeeper: container.resolve())
        }
        
        register(ApiProvider.self) { container in
            DefaultApiProvider(
                config: container.resolve(),
                authProvider: container.resolve()
            )
        }
        
        register(ApiPostsProvider.self) { container in
            DefaultApiPostsProvider(apiProvider: container.resolve())
        }
        
        register(PostsFeedViewModel.self) { container in
            PostsFeedViewModel(apiPostsProvider: container.resolve())
        }
        
        // Register view models that need arguments
        register(PostDetailViewModel.self) { container, postID in
            PostDetailViewModel(
                postID: postID,
                apiPostsProvider: container.resolve()
            )
        }
    }
}
