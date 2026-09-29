//
//  AppCoordinator.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 30.03.2026.
//

import SwiftUI
import Combine
import AuthSDK

protocol CoordinatorProtocol: ObservableObject {
    var childCoordinators: [any CoordinatorProtocol] { get set }
    var path: NavigationPath { get set }
    func start()
}

extension CoordinatorProtocol {
    func addChild(_ coordinator: any CoordinatorProtocol) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(_ coordinator: any CoordinatorProtocol) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}

@MainActor
class AppCoordinator: CoordinatorProtocol {
    @Published var path = NavigationPath()
    var childCoordinators: [any CoordinatorProtocol] = []
    var childCoordinator: (any CoordinatorProtocol)?
    @Published var currentScreen: Screen = .registration
    
    private let sessionObserver: SessionObserving
    private var cancellables = Set<AnyCancellable>()
    
    init(sessionObserver: SessionObserving) {
        self.sessionObserver = sessionObserver
    }
    
    enum Screen: Hashable {
        case registration
        case postsFeed
    }
    
    func start() {
        showRegistration()
        sessionObserver.isAuthenticatedPublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] isAuthenticated in
                self?.currentScreen = isAuthenticated ? .postsFeed : .registration
            }
            .store(in: &cancellables)
    }
    
    func showRegistration() {
        currentScreen = .registration
    }
    
    func showMainFlow() {
        currentScreen = .postsFeed
//        let postsFeedCoordinator = PostsFeedCoordinator()
//        postsFeedCoordinator.delegate = self
//        addChild(postsFeedCoordinator)
//        childCoordinator = postsFeedCoordinator
//        postsFeedCoordinator.start()
    }
}

extension AppCoordinator: PostsFeedCoordinatorDelegate {
    func mainDidLogout() {
    }
}
