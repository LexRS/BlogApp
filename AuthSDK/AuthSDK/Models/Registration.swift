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
    
    public init(userName: String, email: String, password: String) {
        self.userName = userName
        self.email = email
        self.password = password
    }
}

public struct LoginRequest: Encodable {
    public let email: String
    public let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
