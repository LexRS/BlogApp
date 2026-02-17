//
//  ApiError.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 13.02.2026.
//

enum ApiError: Error {
    case invalidURL
    case decodingError
    case networkError(String)
}
