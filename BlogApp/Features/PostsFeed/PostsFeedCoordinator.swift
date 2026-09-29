//
//  PostsFeedCoordinator.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 14.07.2026.
//

import Combine
import SwiftUI

protocol PostsFeedCoordinatorDelegate: AnyObject {
    func mainDidLogout()
}

@MainActor
class PostsFeedCoordinator: CoordinatorProtocol, ObservableObject {
    @Published var path = NavigationPath()
    @Published var modalScreen: ModalScreen? = nil
    
    var childCoordinators: [any CoordinatorProtocol] = []
    
    func start() {
    }
    
    func showAddPostModal() {
        modalScreen = .addPost
    }
    
    func dismissModal() {
        modalScreen = nil
    }
    
    func navigateToPostDetails(_ postID: Int) {
        path.append(PostsFeedScreen.postDetails(postID: postID))
    }
}

extension PostsFeedCoordinator {
    enum ModalScreen: Identifiable, Hashable {
        case addPost
        
        var id: String {
            String(describing: self)
        }
    }
    
    enum PostsFeedScreen: Hashable {
        case postDetails(postID: Int)
    }
}
