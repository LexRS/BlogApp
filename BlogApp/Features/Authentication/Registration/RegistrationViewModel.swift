//
//  RegistrationViewModel.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 03.07.2026.
//

import Combine

// MARK: - ViewModel Protocol
protocol RegistrationViewModelProtocol: ObservableObject {
    var email: String { get set }
    var password: String { get set }
}

@MainActor
class RegistrationViewModel: RegistrationViewModelProtocol {
    struct ScreenTitle {
        let name: String
        let buttonTitle: String
    }
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    let screenNames = [
        ScreenTitle(name: "Registration", buttonTitle: "Register"),
        ScreenTitle(name: "Login", buttonTitle: "Log in")
    ]
}
