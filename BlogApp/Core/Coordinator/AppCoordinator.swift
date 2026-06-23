//
//  AppCoordinator.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 30.03.2026.
//

import SwiftUI
import Combine

protocol Coordinator: ObservableObject {
    associatedtype Route: Hashable
    var path: NavigationPath { get set }
    func navigate(to route: Route)
    func pop()
    func popToRoot()
}

enum AppRoute: Hashable {
    case postDetail(Post)
}

class AppCoordinator: Coordinator {
    @Published var path = NavigationPath()
    @Published var alertMessage: String?
    @Published var showAlert = false
    
    func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func handleError(_ error: NavigationError) {
        alertMessage = error.localizedDescription
        showAlert = true
    }
}

enum NavigationError: Error, LocalizedError {
    case invalidUser
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .invalidUser: return "Invalid user data"
        case .networkError: return "Network connection failed"
        }
    }
}
