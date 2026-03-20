//
//  PostsRouter.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 10.03.2026.
//

import Foundation

enum PostsRouter: ApiRouter {
    case postsFeed(cursor: String? = nil)
    
    var path: String {
        switch self {
        case .postsFeed:
            return "/posts/paginated"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .postsFeed:
            return .GET
        }
    }
    
    var query: [URLQueryItem]? {
        switch self {
        case .postsFeed(let cursor):
            if let cursor {
                return [URLQueryItem(name: "cursor", value: cursor)]
            }
            return nil
        }
    }
    
    var body: Data? {
        nil
    }
}
