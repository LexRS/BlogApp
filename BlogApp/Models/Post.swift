//
//  Post.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 03.02.2026.
//
import Foundation
import Combine

struct Post: Codable, Identifiable {
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

struct PaginatedPosts: Codable {
    let posts: [Post]
    let nextCursor: String
    let prevCursor: String
    let hasBool: Bool
    
    private enum CodingKeys: String, CodingKey {
        case posts = "posts"
        case nextCursor = "next_cursor"
        case prevCursor = "prev_cursor"
        case hasBool = "has_bool"
    }
}

class PostsModel: ObservableObject {
    @Published var posts: [Post] = []
}

extension Post {
    static var MOCK_POSTS = [
        Post(id: 1, title: "Simple post", content: "This post is about nature", author: "Bob Stringer", createdAt: Date.now, updatedAt: Date.now),
        Post(id: 2, title: "Swift tutorial", content: "How to start coding with Swift", author: "John Appleseed", createdAt: Date.now, updatedAt: Date.now),
        Post(id: 3, title: "Learning go", content: "Your best point to start learning GO", author: "Sandra Wolfstein", createdAt: Date.now, updatedAt: Date.now)
    ]
}

