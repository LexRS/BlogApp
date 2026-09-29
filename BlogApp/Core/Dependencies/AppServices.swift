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
    
    // MARK: - Public services
    let sessionProvider: SessionProviderProtocol & SessionObserving
    let authProvider: AuthProviderProtocol
    let apiPostsProvider: ApiPostsProviderProtocol
    
    init() {
        self.config = DefaultConfig()
        self.sessionProvider = AuthAssembly.buildSessionProvider()
        self.apiProvider = DefaultApiProvider(config: config, sessionProvider: sessionProvider)
        self.authProvider = DefaultAuthProvider(apiProvider: apiProvider, sessionProvider: sessionProvider)
        self.apiPostsProvider = DefaultApiPostsProvider(apiProvider: apiProvider)
    }
}
