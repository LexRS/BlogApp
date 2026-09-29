//
//  BlogApp.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 03.02.2026.
//

import SwiftUI

@main
struct BlogApp: App {
    private let services: AppServices
    private let viewModelFactory: ViewModelFactory
    @StateObject private var appCoordinator: AppCoordinator

    init() {
        let services = AppServices()
        self.services = services
        self.viewModelFactory = ViewModelFactory(appServices: services)
        _appCoordinator = StateObject(wrappedValue: AppCoordinator(sessionObserver: services.sessionProvider))
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appCoordinator.currentScreen {
                case .registration:
                    RegistrationView(viewModel: viewModelFactory.makeRegistrationViewModel())
                case .postsFeed:
                    PostsFeedView(viewModel: viewModelFactory.makePostsFeedViewModel())
                }
            }
            .onAppear {
                appCoordinator.start()
            }
        }
        .environment(\.viewModelFactory, viewModelFactory)
    }
}
