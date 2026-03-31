//
//  UpdatePostRequest.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 22.03.2026.
//

struct UpdatePostRequest: Encodable {
    let id: Int
    var title: String?
    var author: String?
    var content: String?
}
