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
    @State var path = NavigationPath()
    var childCoordinators: [any CoordinatorProtocol] = []
    
    func start() {
    }
    
    //=====New functions
    @Published var modalScreen: ModalScreen? = nil
    
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
