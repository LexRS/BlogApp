//
//  AddPostDependencies.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 04.03.2026.
//

import Foundation
import ComposableArchitecture

enum AddPostKey: DependencyKey {
    static let liveValue: AddPostNetworking = AddPostService()
}

extension DependencyValues {
    var addPostService: AddPostNetworking {
        get { self[AddPostKey.self] }
        set { self[AddPostKey.self] = newValue }
    }
}
