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
    private let sessionProvider: SessionProviderProtocol
    private let apiProvider: ApiProviderProtocol
    private let authProvider: AuthProviderProtocol
    private let apiPostsProvider: ApiPostsProviderProtocol
    
    // MARK: - View Models
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
