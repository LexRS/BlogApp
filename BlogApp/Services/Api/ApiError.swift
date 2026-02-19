//
//  ApiError.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 13.02.2026.
//

import Foundation

enum ApiError: LocalizedError, Equatable {
    case invalidURL
    case decodingError
    case networkError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .decodingError:
            return "Failed to decode response"
        case .networkError(let message):
            return "Network error: \(message)"
        }
    }
}
