//
//  RegistrationRequest.swift
//  AuthSDK
//
//  Created by Алексей Поддубный on 09.07.2026.
//

import Foundation

public struct AuthSession {
    public let accessToken: String
    public let refreshToken: String
    public let expiresAt: Date
    public let user: User
    
    public var isValid: Bool {
        return Date() < expiresAt
    }
}
