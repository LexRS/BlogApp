//
//  PostsFeedView.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 19.02.2026.
//

import SwiftUI
import ComposableArchitecture

// Create an Equatable struct for observed state
struct PostsFeedViewState: Equatable {
    let posts: IdentifiedArrayOf<Post>
    let isLoading: Bool
    let isLoadingMore: Bool
    let hasMore: Bool
}

struct PostsFeedView: View {
    @Perception.Bindable var store: StoreOf<PostsFeedFeature>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack {
                ZStack(alignment: .bottomTrailing) {
                    if store.posts.isEmpty {
                        NodataView()
                    } else {
                        postsList
                        floatingButton
                    }
                }
                .navigationTitle("Blog Posts")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        refreshButton
                    }
                }
                .onAppear {
                    store.send(.onAppear)
                }
                .sheet(item: $store.scope(state: \.newPost, action: \.newPost)) { newPostStore in
                    AddPostView(store: newPostStore)
                }
                .navigationDestination(item: $store.scope(state: \.postDetailed, action: \.postDetailed), destination: { detailPostStore in
                    DetailedPostView(store: detailPostStore)
                })
                .alert(
                    "Error",
                    isPresented: Binding(
                        get: { store.errorMessage != nil },
                        set: { if !$0 { store.send(.dismissError) } }
                    )
                ) {
                    Button("OK") {
                        store.send(.dismissError)
                    }
                } message: {
                    if let error = store.errorMessage {
                        Text(error)
                    }
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var postsList: some View {
        WithViewStore(store, observe: { state in
            PostsFeedViewState(
                            posts: state.posts,
                            isLoading: state.isLoading,
                            isLoadingMore: state.isLoadingMore,
                            hasMore: state.hasMore
                        )
        }) { viewStore in
            ZStack {
                if viewStore.isLoading && viewStore.posts.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        postsSection(for: viewStore)
                        loadingMoreSection(for: viewStore)
                    }
                    .listStyle(.plain)
                    .refreshable {
                        store.send(.fetchPosts)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func postsSection(for viewStore: PostsFeedViewStore) -> some View {
        ForEach(viewStore.posts) { post in
            PostRow(post: post)
                .onTapGesture {
                    store.send(.postFromListSelected(post))
                }
                .onAppear {
                    if post.id == viewStore.posts.last?.id && viewStore.hasMore {
                        store.send(.fetchMorePosts)
                    }
                }
        }
    }
    
    @ViewBuilder
    private func loadingMoreSection(for viewStore: PostsFeedViewStore) -> some View {
        if viewStore.isLoadingMore {
            HStack {
                Spacer()
                ProgressView()
                    .padding()
                Spacer()
            }
        }
    }
    
    private var floatingButton: some View {
        Button {
            store.send(.addButtonTapped)
        } label: {
            Image(systemName: "plus")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Color.blue)
                .clipShape(Circle())
                .shadow(radius: 4, y: 2)
        }
        .padding(.trailing, 20)
        .padding(.bottom, 20)
    }
    
    private var refreshButton: some View {
        Button(action: { store.send(.fetchPosts) }) {
            Image(systemName: "arrow.clockwise")
        }
        .disabled(store.isLoading)
    }
}

// Typealias to make the code cleaner
typealias PostsFeedViewStore = ViewStore<PostsFeedViewState, PostsFeedFeature.Action>

//#Preview {
//    PostsFeedView(
//        store: Store(initialState: PostsFeedFeature.State()) {
//            PostsFeedFeature()
//        } withDependencies: {
//            // Override with preview value
//            $0.postsClient = MockPostsClient()
//        }
//    )
//}
