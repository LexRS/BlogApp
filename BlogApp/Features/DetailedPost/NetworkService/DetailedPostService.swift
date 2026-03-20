//
//  DetailedPostService.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 04.03.2026.
//

import Foundation

protocol DetailedPostNetworking: Sendable {
    func fetchPost(_ postID: Int) async throws -> Post
}

struct DetailedPostService: DetailedPostNetworking {
    func fetchPost(_ postID: Int) async throws -> Post {
        guard let url = URL(string: "Content-Type") else {
            throw ApiError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let response = try decoder.decode(Post.self, from: data)
        return response
    }
}
