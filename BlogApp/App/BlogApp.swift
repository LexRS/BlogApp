//
//  BlogAppApp.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 03.02.2026.
//

import SwiftUI

@main
struct MVVMCoordinatorApp: App {
    @StateObject private var coordinator = AppCoordinator()
    private var container = AppDIContainer()
    
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                PostsFeedView(coordinator: coordinator, viewModel: container.resolve())
                .navigationDestination(for: AppRoute.self) { route in
                    destinationView(for: route)
                }
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .postDetail(let post):
            PostDetailView(coordinator: coordinator, viewModel: container.resolve(argument: post.id))
        }
    }
}
