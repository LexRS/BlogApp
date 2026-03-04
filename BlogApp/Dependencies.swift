//
//  Dependencies.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 18.02.2026.
//

import ComposableArchitecture
import Foundation

extension ApiClient: DependencyKey {
    static let liveValue = ApiClient.live
    static let testValue = ApiClient(
        fetchPosts: { _ in
            PostsResponse(
                posts: [
                    Post(id: 1, title: "Test post", content: "This post is about nature", author: "Bob Stringer", createdAt: Date.now, updatedAt: Date.now)
                ],
                nextCursor: nil,
                prevCursor: nil,
                hasMore: false
            )
        },
        createPost: { post in
            Post(
                id: 1,
                title: post.title,
                content: post.content,
                author: post.author,
                createdAt: Date(),
                updatedAt: Date()
            )
        },
        fetchPost: { postID in
            Post(
                id: postID,
                title: "post.title",
                content: "post.content",
                author: "post.author",
                createdAt: Date(),
                updatedAt: Date()
            )
        }
    )
}

extension DependencyValues {
    var apiClient: ApiClient {
        get { self[ApiClient.self] }
        set { self[ApiClient.self] = newValue }
    }
}
