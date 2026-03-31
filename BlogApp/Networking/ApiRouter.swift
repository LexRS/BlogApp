//
//  ApiRouter.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 07.03.2026.
//

import Foundation

protocol ApiRouter {
    var path: String { get }
    var method: HttpMethod { get }
    var query: [URLQueryItem]? { get }
    var body: Data? { get }
}

enum HttpMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

extension ApiRouter {
    func encodeToJSON<T: Encodable>(_ value: T) -> Data? {
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .sortedKeys
            
            return try encoder.encode(value)
        } catch {
            // In production, you'd want to log this properly
            assertionFailure("Failed to encode \(T.self): \(error)")
            return nil
        }
    }
}

enum AuthRouter: ApiRouter {
    
    case login(email: String, password: String)
    case refresh(token: String)

    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .refresh:
            return "/auth/refresh"
        }
    }

    var method: HttpMethod {
        switch self {
        case .login, .refresh:
            return .POST
        }
    }

    var query: [URLQueryItem]? {
        nil
    }

    var body: Data? {
        nil
//        switch self {
//
//        case let .login(email, password):
//            return try? JSONEncoder().encode(
//                LoginRequest(email: email, password: password)
//            )
//
//        case let .refresh(token):
//            return try? JSONEncoder().encode(
//                RefreshRequest(token: token)
//            )
//        }
    }
}
