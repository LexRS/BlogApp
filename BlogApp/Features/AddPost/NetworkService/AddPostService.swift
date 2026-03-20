//
//  AddPostService.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 04.03.2026.
//

import Foundation

protocol AddPostNetworking: Sendable {
    func createPost(_ post: CreatePostRequest) async throws -> Post
}

// #Warning
struct AddPostService: AddPostNetworking {
    func createPost(_ post: CreatePostRequest) async throws -> Post {
        guard let url = URL(string: "Content-Type") else {
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
        let response = try decoder.decode(Post.self, from: data)
        return response
    }
}
