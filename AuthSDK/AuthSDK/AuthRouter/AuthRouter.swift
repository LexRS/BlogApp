//
//  AuthRouter.swift
//  AuthSDK
//
//  Created by Алексей Поддубный on 09.07.2026.
//

import Foundation
import Core

enum AuthRouter: ApiRouter {
    case register(username: String, email: String, password: String)
    case login(email: String, password: String)

    var path: String {
        switch self {
        case .register(_, _, _):
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
        case .register(let username, let email, let password):
            return try? JSONEncoder().encode(
                RegistrationRequest(userName: username, email: email, password: password)
            )
        case let .login(email, password):
            return try? JSONEncoder().encode(
                LoginRequest(email: email, password: password)
            )
        }
    }
}
