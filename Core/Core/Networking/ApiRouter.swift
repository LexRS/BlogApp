//
//  ApiRouter.swift
//  Core
//
//  Created by Алексей Поддубный on 11.07.2026.
//

import Foundation

public protocol ApiRouter {
    var path: String { get }
    var method: HttpMethod { get }
    var query: [URLQueryItem]? { get }
    var body: Data? { get }
}

public enum HttpMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

public extension ApiRouter {
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
