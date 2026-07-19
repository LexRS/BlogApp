//
//  BlogAppApp.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 03.02.2026.
//

import SwiftUI

@main
struct MVVMCoordinatorApp: App {
    @StateObject private var appCoordinator = AppCoordinator()
    let services = AppServices()
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appCoordinator.currentScreen {
                case .registration:
                    RegistrationView()
                        .environmentObject(appCoordinator)
                case .postsFeed:
                    PostsFeedView()
                        .environmentObject(appCoordinator)
                }
            }
            .onAppear {
                appCoordinator.start()
            }
        }
        .environmentObject(services.registrationViewModel)
        .environmentObject(services.postsFeedViewModel)
    }
}

//import SwiftUI
//
//@main
//struct MVVMCoordinatorApp: App {
//    @StateObject private var coordinator = AppCoordinator()
//    private var container = AppDIContainer()
//    
//    
//    var body: some Scene {
//        WindowGroup {
//            NavigationStack(path: $coordinator.path) {
//                RegistrationView(coordinator: coordinator, viewModel: container.resolve())
//                .navigationDestination(for: AppRoute.self) { route in
//                    destinationView(for: route)
//                }
//            }
//        }
//    }
//    
//    @ViewBuilder
//    private func destinationView(for route: AppRoute) -> some View {
//        switch route {
//        case .registration:
//            RegistrationView(coordinator: coordinator, viewModel: container.resolve())
//        case .postsFeed:
//            PostsFeedView(coordinator: coordinator, viewModel: container.resolve())
//        case .postDetail(let post):
//            PostDetailView(coordinator: coordinator, viewModel: container.resolve(argument: post.id))
//        }
//    }
//}
