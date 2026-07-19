//
//  Registration.swift
//  AuthSDK
//
//  Created by Алексей Поддубный on 11.07.2026.
//

import Foundation

public struct RegistrationRequest: Encodable {
    public let userName: String
    public let email: String
    public let password: String
}

struct LoginRequest: Encodable {
    public let email: String
    public let password: String
}
