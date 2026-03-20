//
//  BlogAppApp.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 03.02.2026.
//

import SwiftUI
import ComposableArchitecture

@main
struct BlogApp: App {
    var body: some Scene {
        WindowGroup {
            PostsFeedView(
                store: Store(initialState: PostsFeedFeature.State()) {
                    PostsFeedFeature()
                }
            )
        }
    }
}
