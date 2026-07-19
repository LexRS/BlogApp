//
//  PostsFeedCoordinator.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 14.07.2026.
//

import Combine

protocol MainCoordinatorDelegate: AnyObject {
    func mainDidLogout()
}

class MainCoordinator: CoordinatorNew, ObservableObject {
    weak var delegate: MainCoordinatorDelegate?
    var childCoordinators: [any CoordinatorNew] = []
    @Published var currentTab: MainTab = .dashboard
    @Published var selectedItem: Any?
    
    enum MainTab {
        case dashboard
        case profile
        case settings
    }
    
    func start() {
        currentTab = .dashboard
    }
    
    func navigateToProfile() {
        currentTab = .profile
    }
    
    func navigateToSettings() {
        currentTab = .settings
    }
}
