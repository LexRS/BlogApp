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
    @Published var modalScreen: ModalScreen? = nil
    
    private let sessionObserver: SessionObserving
    private var cancellables = Set<AnyCancellable>()
    
    init(sessionObserver: SessionObserving) {
        self.sessionObserver = sessionObserver
    }
    
    enum Screen: Hashable {
        case registration
        case postsFeed
    }
    
    enum PostsFeedScreen: Hashable {
        case postDetails(postID: Int)
    }
    
    func start() {
        sessionObserver.isAuthenticatedPublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] isAuthenticated in
                self?.currentScreen = isAuthenticated ? .postsFeed : .registration
            }
            .store(in: &cancellables)
        showRegistration()
    }
    
    func showRegistration() {
        currentScreen = .postsFeed
    }
    
    func showMainFlow() {
        currentScreen = .postsFeed
        let postsFeedCoordinator = PostsFeedCoordinator()
        postsFeedCoordinator.delegate = self
        addChild(postsFeedCoordinator)
        childCoordinator = postsFeedCoordinator
        postsFeedCoordinator.start()
    }
    
    func navigateToPostDetails(_ postID: Int) {
        path.append(PostsFeedScreen.postDetails(postID: postID))
    }
    
    func showAddPostModal() {
        modalScreen = .addPost
    }
    
    func dismissModal() {
        modalScreen = nil
    }
}

extension AppCoordinator: PostsFeedCoordinatorDelegate {
    func mainDidLogout() {
    }
}

extension AppCoordinator {
    enum ModalScreen: Identifiable, Hashable {
        case addPost
        // case editPost(Post) // Example for later
        
        var id: String {
            // Conforming to Identifiable so we can use .sheet(item:)
            String(describing: self)
        }
    }
}
