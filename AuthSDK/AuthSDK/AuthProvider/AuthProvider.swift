//
//  AuthProvider.swift
//  AuthSDK
//
//  Created by Алексей Поддубный on 10.07.2026.
//

import Foundation
import Core

public protocol AuthProviderProtocol {
    func register(username: String, email: String, password: String) async throws -> AuthResponse
    func login(email: String, password: String) async throws -> AuthResponse
}

public class DefaultAuthProvider: AuthProviderProtocol {
    private var apiProvider: ApiProvider
    
    public init(apiProvider: ApiProvider) {
        self.apiProvider = apiProvider
    }
    
    public func register(username: String, email: String, password: String) async throws -> AuthResponse {
        let router = AuthRouter.register(username: username, email: email, password: password)
        let result: AuthResponse = try await apiProvider.request(router)
        return result
    }
    
    public func login(email: String, password: String) async throws -> AuthResponse {
        let router = AuthRouter.login(email: email, password: password)
        let result: AuthResponse = try await apiProvider.request(router)
        return result
    }
}

public class AuthServiceMock: AuthProviderProtocol {
    private let result: Result<AuthResponse, AuthError>
    
    public init(result: Result<AuthResponse, AuthError> = .success(makeMockAuthResponse())) {
        self.result = result
    }
    
    public func register(username: String, email: String, password: String) async throws -> AuthResponse {
        switch result {
        case .success:
            let mockResponse = AuthResponse(token: "mock-token", user: UserResponse(id: 1, username: username, email: email, role: "mock"))
            return mockResponse
        case .failure(_):
            throw MockError.authMockError
        }
    }
    
    public func login(email: String, password: String) async throws -> AuthResponse {
        switch result {
        case .success:
            let mockResponse = AuthResponse(token: "mock-token", user: UserResponse(id: 1, username: "mock-username", email: email, role: "mock"))
            return mockResponse
        case .failure(_):
            throw MockError.authMockError
        }
    }
    
    enum MockError: Error {
        case authMockError
    }
    
    public static func makeMockAuthResponse() -> AuthResponse {
        return AuthResponse(token: "mock-token", user: UserResponse(id: 1, username: "mock-username", email: "mock-email", role: "mock"))
    }
}
