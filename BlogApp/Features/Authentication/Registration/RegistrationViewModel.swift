//
//  RegistrationViewModel.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 03.07.2026.
//

import Foundation
import Combine
import AuthSDK

// MARK: - ViewModel Protocol
protocol RegistrationViewModelProtocol: ObservableObject {
    var userName: String? { get set }
    var email: String { get set }
    var password: String { get set }
    var errorMessage: String? { get }
    var isLoading: Bool { get }
    
    func registerButtonTapped()
    func loginButtonTapped()
}

extension RegistrationViewModel {
    struct ScreenTitle {
        let name: String
        let buttonTitle: String
    }
}

// MARK: - ViewModel implementation
@MainActor
class RegistrationViewModel: RegistrationViewModelProtocol {
    @Published var userName: String?
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var isAuthorized: Bool = false
    
    private let authProvider: AuthProviderProtocol
    
    init(authProvider: AuthProviderProtocol) {
        self.authProvider = authProvider
        print("RegistrationViewModel:", ObjectIdentifier(self))
    }
    
    let screenNames = [
        ScreenTitle(name: "Registration", buttonTitle: "Register"),
        ScreenTitle(name: "Login", buttonTitle: "Log in")
    ]
    
    func registerButtonTapped() {
        guard let userName, isRegistrationDataValid() else {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task { @MainActor in
            do {
                let response = try await authProvider.register(username: userName, email: email, password: password)
                handleSuccess(response)
            } catch {
                handleError(error)
            }
        }
    }
    
    func loginButtonTapped() {
        guard isLoginDataValid() else {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task { @MainActor in 
            do {
                let response = try await authProvider.login(email: email, password: password)
                handleSuccess(response)
            } catch {
                handleError(error)
            }
        }
    }
    
    @MainActor
    private func handleSuccess(_ response: AuthResponse) {
        isLoading = false
        errorMessage = nil
        isAuthorized = true
    }
    
    @MainActor
    private func handleError(_ error: Error) {
        isLoading = false
        errorMessage = error.localizedDescription
    }
    
    private func isRegistrationDataValid() -> Bool {
        guard userName != nil else {
            errorMessage = "Enter user name, please"
            return false
        }
        guard email != "" else {
            errorMessage = "Email field should not be empty"
            return false
        }
        guard password != "" else {
            errorMessage = "Password field should not be empty"
            return false
        }
        return true
    }
    
    private func isLoginDataValid() -> Bool {
        guard email != "" else {
            errorMessage = "Email field should not be empty"
            return false
        }
        guard password != "" else {
            errorMessage = "Password field should not be empty"
            return false
        }
        return true
    }
}
