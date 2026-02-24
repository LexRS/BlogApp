//
//  ApiClient.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 13.02.2026.
//

import Foundation

struct ApiClient {
    var fetchPosts: @Sendable (_ cursor: String?) async throws -> PostsResponse
    var createPost: @Sendable (_ post: CreatePostRequest) async throws -> Post
    
    static let live = Self(
        fetchPosts: { cursor in
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
        },
        createPost: { post in
            guard let url = URL(string: baseURL + "/posts") else {
                throw ApiError.invalidURL
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try encoder.encode(post)
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let response = try decoder.decode(Post.self, from: data)
            return response
        }
    )
}

extension ApiClient {
    static let baseURL = "http://localhost:8080/api/v1"
}
