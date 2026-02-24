//
//  ApiClient.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 13.02.2026.
//

import Foundation

struct ApiClient {
    var fetchPosts: @Sendable (_ cursor: String?) async throws -> PostsResponse
    
    static let live = Self(fetchPosts: { cursor in
        var urlComponents = URLComponents(string: baseURL + "/posts/paginated")
        if let cursor {
            urlComponents?.queryItems = [URLQueryItem(name: "cursor", value: cursor)]
        }
        guard let url = urlComponents?.url else { throw ApiError.invalidURL }
        print(url.absoluteString)
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let response = try decoder.decode(PostsResponse.self, from: data)
        return response
    })
}

extension ApiClient {
    static let baseURL = "http://localhost:8080/api/v1"
}
