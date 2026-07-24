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

class PostsFeedCoordinator: CoordinatorProtocol, ObservableObject {
    @State var path = NavigationPath()
    weak var delegate: PostsFeedCoordinatorDelegate?
    var childCoordinators: [any CoordinatorProtocol] = []
    @Published var currentTab: MainTab = .dashboard
    
    enum MainTab {
        case dashboard
        case profile
        case settings
    }
    
    func start() {
        currentTab = .dashboard
    }
}

//final class PostsFeedCoordinator: ObservableObject {
//    @Published var path = NavigationPath()
//
//    func start() {
//        path.removeLast(path.count)
//    }
//
//    func showPostDetails(postID: Int) {
//        path.append(Route.postDetails(postID))
//    }
//}
