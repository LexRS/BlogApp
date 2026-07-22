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
        guard let registrationRequest = createRegistrationRequest() else {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task { @MainActor in
            do {
                let response = try await authProvider.register(registrationRequest)
                handleSuccess(response)
            } catch {
                handleError(error)
            }
        }
    }
    
    func loginButtonTapped() {
        guard let loginRequest = createLoginRequest() else {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task { @MainActor in 
            do {
                let response = try await authProvider.login(loginRequest)
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
    
    private func createRegistrationRequest() -> RegistrationRequest? {
        guard let userName else {
            errorMessage = "Enter user name, please"
            return nil
        }
        guard email != "" else {
            errorMessage = "Email field should not be empty"
            return nil
        }
        guard password != "" else {
            errorMessage = "Password field should not be empty"
            return nil
        }
        return RegistrationRequest(userName: userName, email: email, password: password)
    }
    
    private func createLoginRequest() -> LoginRequest? {
        guard email != "" else {
            errorMessage = "Email field should not be empty"
            return nil
        }
        guard password != "" else {
            errorMessage = "Password field should not be empty"
            return nil
        }
        return LoginRequest(email: email, password: password)
    }
}
