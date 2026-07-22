//
//  RegistrationCoordinator.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 14.07.2026.
//

import Combine

protocol RegistrationCoordinatorDelegate: AnyObject {
    func registrationDidFinishSuccess()
}

class RegistrationCoordinator: CoordinatorProtocol, ObservableObject {
    func start() {
    }
    
    var childCoordinators: [any CoordinatorProtocol] = []
    weak var delegate: RegistrationCoordinatorDelegate?
}
