//
//  BlogAppApp.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 03.02.2026.
//

import SwiftUI
import ComposableArchitecture

@main
struct BlogApp: App {
    @StateObject private var appCoordinator: AppCoordinator
    private let dependencies: Dependencies
    
    init() {
        let container = Dependencies()
        dependencies = container
        _appCoordinator = StateObject(wrappedValue: AppCoordinator(container: container))
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appCoordinator.path) {
                appCoordinator.makeRootView()
            }
            .environmentObject(appCoordinator)
        }
    }
}
