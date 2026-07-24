//
//  AuthRouter.swift
//  AuthSDK
//
//  Created by Алексей Поддубный on 09.07.2026.
//

import Foundation
import Core

enum AuthRouter: ApiRouter {
    case register(registrationRequest: RegistrationRequest)
    case login(loginRequest: LoginRequest)

    var path: String {
        switch self {
        case .register(_):
            return "/register"
        case .login:
            return "/login"
        }
    }

    var method: HttpMethod {
        switch self {
        case .register, .login:
            return .POST
        }
    }

    var query: [URLQueryItem]? {
        nil
    }

    var body: Data? {
        switch self {
        case .register(let registrationRequest):
            return try? JSONEncoder().encode(registrationRequest)
        case let .login(loginRequest):
            return try? JSONEncoder().encode(loginRequest)
        }
    }
}
