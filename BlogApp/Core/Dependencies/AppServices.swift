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
    // MARK: - Services
    private let config: ConfigProtocol
    private let apiProvider: ApiProviderProtocol
    private let authProvider: AuthProviderProtocol
    private let apiPostsProvider: ApiPostsProviderProtocol
    
    // MARK: - Public services
    let sessionProvider: SessionProviderProtocol & SessionObserving
    
    // MARK: - View Models
    let registrationViewModel: RegistrationViewModel
    let postsFeedViewModel: PostsFeedViewModel
    let postDetailsViewModel: PostDetailViewModel
    let addPostViewModel: AddPostViewModel
    
    init() {
        self.config = DefaultConfig()
        self.sessionProvider = AuthAssembly.buildSessionProvider()
        self.apiProvider = DefaultApiProvider(config: config, sessionProvider: sessionProvider)
        self.authProvider = DefaultAuthProvider(apiProvider: apiProvider, sessionProvider: sessionProvider)
        self.apiPostsProvider = DefaultApiPostsProvider(apiProvider: apiProvider)
        self.registrationViewModel = RegistrationViewModel(authProvider: authProvider)
        self.postsFeedViewModel = PostsFeedViewModel(apiPostsProvider: apiPostsProvider)
        self.postDetailsViewModel = PostDetailViewModel(apiPostsProvider: apiPostsProvider)
        self.addPostViewModel = AddPostViewModel(apiPostProvider: apiPostsProvider)
    }
}
