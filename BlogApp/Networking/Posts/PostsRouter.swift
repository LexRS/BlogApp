//
//  PostsRouter.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 10.03.2026.
//

import Foundation

enum PostsRouter: ApiRouter {
    case postsFeed(cursor: String? = nil)
    case detailedPost(postID: Int)
    case createPost(postRequest: CreatePostRequest)
    
    var path: String {
        switch self {
        case .postsFeed:
            return "/posts/paginated"
        case .detailedPost(let postID):
            return "/posts/\(postID)"
        case .createPost(let postRequest):
            return "/posts"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .postsFeed:
            return .GET
        case .detailedPost:
            return .GET
        case .createPost:
            return .POST
        }
    }
    
    var query: [URLQueryItem]? {
        switch self {
        case .postsFeed(let cursor):
            if let cursor {
                return [URLQueryItem(name: "cursor", value: cursor)]
            }
            return nil
        default:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .createPost(let postRequest):
            return encodeToJSON(postRequest)
        default:
            return nil
        }
    }
}
