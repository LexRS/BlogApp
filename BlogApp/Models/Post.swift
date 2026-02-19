//
//  Post.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 03.02.2026.
//
import Foundation
import Combine

struct Post: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let content: String
    let author: String
    let createdAt: Date
    let updatedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case content = "content"
        case author = "author"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct PostsResponse: Codable, Equatable {
    let posts: [Post]
    let nextCursor: String?
    let prevCursor: String?
    let hasMore: Bool
    
    private enum CodingKeys: String, CodingKey {
        case posts = "posts"
        case nextCursor = "next_cursor"
        case prevCursor = "prev_cursor"
        case hasMore = "has_more"
    }
}
