//
//  ContentView.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 03.02.2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = PostsModel()
    @State private var errorString: String?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 32) {
                ForEach(model.posts) { post in
                    FeedCell(post: post)
                }
            }
        }
        .task {
            do {
                model.posts = try await ApiClient.live.fetchPosts("")
            } catch {
                errorString = error.localizedDescription
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
