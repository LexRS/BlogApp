//
//  ApiClient.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 13.02.2026.
//

import Foundation

struct ApiClient {
    var fetchPosts: @Sendable (_ cursor: String) async throws -> [Post]
    
    static let live = Self(fetchPosts: { cursor in
        let urlString = baseURL + "/posts"
        guard let url = URL(string: urlString) else { throw ApiError.invalidURL }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let response = try decoder.decode([Post].self, from: data)
        return response
    })
}

extension ApiClient {
    static let baseURL = "http://localhost:8080/api/v1"
}
