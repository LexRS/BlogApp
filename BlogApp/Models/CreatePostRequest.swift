//
//  CreatePostRequest.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 24.02.2026.
//

struct CreatePostRequest: Codable, Equatable {
    let title: String
    let content: String
    let author: String
}
