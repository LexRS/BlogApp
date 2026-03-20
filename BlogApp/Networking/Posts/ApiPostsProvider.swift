//
//  ApiPostsProvider.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 10.03.2026.
//

import Foundation

protocol ApiPostsProvider: AnyObject {
    func getPosts(cursor: String?) async throws -> PostsResponse
}

final class DefaultApiPostsProvider: ApiPostsProvider {
    private let apiProvider: ApiProvider
    
    init(apiProvider: ApiProvider) {
        self.apiProvider = apiProvider
    }
    
    func getPosts(cursor: String? = nil) async throws -> PostsResponse {
        let router = PostsRouter.postsFeed(cursor: cursor)
        let response: PostsResponse = try await apiProvider.request(router)
        return response
    }
}
