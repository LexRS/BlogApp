//
//  DetailedPostDependencies.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 04.03.2026.
//

import Foundation
import ComposableArchitecture

enum DetailedPostKey: DependencyKey {
    static let liveValue: DetailedPostNetworking = DetailedPostService()
}

extension DependencyValues {
    var detailedPostService: DetailedPostNetworking {
        get { self[DetailedPostKey.self] }
        set { self[DetailedPostKey.self] = newValue }
    }
}
