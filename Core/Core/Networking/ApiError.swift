//
//  ApiError.swift
//  Core
//
//  Created by Алексей Поддубный on 11.07.2026.
//

import Foundation

public enum ApiError: LocalizedError, Equatable {
    case invalidURL
    case decodingError
    case networkError(String)
    case unexpectedEmptyResponse
    case emptyData
    case unauthorized
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .decodingError:
            return "Failed to decode response"
        case .networkError(let message):
            return "Network error: \(message)"
        case .unexpectedEmptyResponse:
            return "Unexpected empty response"
        case .emptyData:
            return "Empty data"
        case .unauthorized:
            return "Unauthorized access"
        }
    }
}
