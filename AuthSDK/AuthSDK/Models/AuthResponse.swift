//
//  AuthResponse.swift
//  AuthSDK
//
//  Created by Алексей Поддубный on 11.07.2026.
//

import Foundation

public struct AuthResponse: Decodable {
    let token: String
    let user: UserResponse
}

struct UserResponse: Decodable {
    let id: Int // или String, в зависимости от вашей бэкенд-модели
    let username: String
    let email: String
    let role: String
}
