//
//  PostsFeedView.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 19.02.2026.
//

import SwiftUI
import ComposableArchitecture

struct PostsFeedView: View {
    let store: StoreOf<PostsFeedFeature>
    
    var body: some View {
        NavigationStack {
            WithViewStore(store, observe: { $0 }) { viewStore in
                ZStack {
                    if viewStore.isLoading && viewStore.posts.isEmpty {
                        ProgressView()
                    } else {
                        List {
                            ForEach(viewStore.posts) { post in
                                PostRow(post: post)
                                    .onAppear {
                                        if post.id == viewStore.posts.last?.id && viewStore.hasMore {
                                            viewStore.send(.fetchMorePosts)
                                        }
                                    }
                            }
                            
                            if viewStore.isLoadingMore {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                        .padding()
                                    Spacer()
                                }
                            }
                        }
                        .listStyle(.plain)
                        .refreshable {
                            await viewStore.send(.fetchPosts).finish()
                        }
                    }
                }
                .navigationTitle("Blog Posts")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewStore.send(.fetchPosts)
                        }) {
                            Image(systemName: "arrow.clockwise")
                        }
                        .disabled(viewStore.isLoading)
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .alert(
                    "Error",
                    isPresented: viewStore.binding(
                        get: \.showErrorAlert,
                        send: .dismissError
                    )
                ) {
                    Button("OK") {
                        viewStore.send(.dismissError)
                    }
                } message: {
                    if let error = viewStore.errorMessage {
                        Text(error)
                    }
                }
            }
        }
    }
}
