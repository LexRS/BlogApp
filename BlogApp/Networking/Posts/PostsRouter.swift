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
    case delete(postID: Int)
    case updatePost(postRequest: UpdatePostRequest)
    
    var path: String {
        switch self {
        case .postsFeed:
            return "/posts/paginated"
        case .detailedPost(let postID):
            return "/posts/\(postID)"
        case .createPost:
            return "/posts"
        case .delete(let postID):
            return "/posts/\(postID)"
        case .updatePost(let postRequest):
            return "/posts/\(postRequest.id)"
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
        case .delete:
            return .DELETE
        case .updatePost:
            return .PUT
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
        case .updatePost(let postRequest):
            return encodeToJSON(postRequest)
        default:
            return nil
        }
    }
}
