//
//  AppCoordinator.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 30.03.2026.
//

import SwiftUI
import Combine

protocol CoordinatorNew: ObservableObject {
    var childCoordinators: [any CoordinatorNew] { get set }
    func start()
}

extension CoordinatorNew {
    func addChild(_ coordinator: any CoordinatorNew) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(_ coordinator: any CoordinatorNew) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}

class AppCoordinator: CoordinatorNew {
    var childCoordinators: [any CoordinatorNew] = []
    @Published var currentScreen: Screen = .registration
    //private let window: UIWindow?
    
    enum Screen {
        case registration
        case postsFeed
    }
    
//    init(window: UIWindow? = nil) {
//        self.window = window
//    }
    
    func start() {
        //showLoader()
        showRegistration()
    }
    
    func showRegistration() {
        currentScreen = .registration
        //let loaderCoordinator = RegistrationCoordinator()
        //loaderCoordinator.delegate = self
        //addChild(loaderCoordinator)
        //loaderCoordinator.start()
    }
    
    func showMainFlow() {
        currentScreen = .postsFeed
        //let mainCoordinator = MainCoordinator()
        //mainCoordinator.delegate = self
        //addChild(mainCoordinator)
        //mainCoordinator.start()
    }
}

//extension AppCoordinator: RegistrationCoordinatorDelegate {
//    func loaderDidFinish(with result: LoadingResult) {
//        switch result {
//        case .authenticated:
//            showMainFlow()
//        case .unauthenticated:
//            showAuthFlow()
//        case .error:
//            // Show error or retry
//            break
//        }
//    }
//}
//
//extension AppCoordinator: AuthCoordinatorDelegate {
//    func authDidSucceed() {
//        // Remove auth coordinator
//        childCoordinators.removeAll { $0 is AuthCoordinator }
//        showMainFlow()
//    }
//}
//
//extension AppCoordinator: MainCoordinatorDelegate {
//    func mainDidLogout() {
//        childCoordinators.removeAll { $0 is MainCoordinator }
//        showAuthFlow()
//    }
//}

// Below old version of coordinator

//protocol Coordinator: ObservableObject {
//    var path: NavigationPath { get set }
//    // TODO: Bad practice that parameter just of type Hashable
//    func navigate<Route: Hashable>(to route: Route)
//    func pop()
//    func popToRoot()
//}
//
//enum AppRoute: Hashable {
//    case registration
//    case postDetail(Post)
//    case postsFeed
//}
//
//class MockCoordinator: Coordinator {
//    var path: NavigationPath = NavigationPath()
//    
//    func navigate<Route>(to route: Route) where Route : Hashable {
//        print("Vse budet horosho")
//    }
//    
//    func pop() {
//        print("Vse budet horosho")
//    }
//    
//    func popToRoot() {
//        print("Vse budet horosho")
//    }
//}
//
//class AppCoordinator: Coordinator {
//    @Published var path = NavigationPath()
//    @Published var alertMessage: String?
//    @Published var showAlert = false
//
//    init() {
//        print("AppCoordinator init")
//    }
//    
//    func navigate<Route>(to route: Route) where Route : Hashable {
//        path.append(route)
//    }
//    
//    func pop() {
//        guard !path.isEmpty else { return }
//        path.removeLast()
//    }
//    
//    func popToRoot() {
//        path.removeLast(path.count)
//    }
//    
//    func handleError(_ error: NavigationError) {
//        alertMessage = error.localizedDescription
//        showAlert = true
//    }
//}
//
//enum NavigationError: Error, LocalizedError {
//    case invalidUser
//    case networkError
//    
//    var errorDescription: String? {
//        switch self {
//        case .invalidUser: return "Invalid user data"
//        case .networkError: return "Network connection failed"
//        }
//    }
//}
