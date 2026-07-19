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

class RegistrationCoordinator: CoordinatorNew, ObservableObject {
    func start() {
    }
    
    var childCoordinators: [any CoordinatorNew] = []
    weak var delegate: RegistrationCoordinatorDelegate?
}
