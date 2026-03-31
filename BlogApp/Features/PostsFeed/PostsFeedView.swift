//
//  PostsFeedView.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 19.02.2026.
//

import SwiftUI

struct PostsFeedView: View {
    @StateObject private var viewModel: PostsFeedViewModel
    
    init(viewModel: PostsFeedViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                if viewModel.posts.isEmpty {
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
                viewModel.onAppear()
            }
            .alert(
                "Error",
                isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.dismissError() } }
                )
            ) {
                Button("OK") {
                    viewModel.dismissError()
                }
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var postsList: some View {
        ZStack {
            if viewModel.isLoading && viewModel.posts.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    postsSection()
                    loadingMoreSection()
                }
                .listStyle(.plain)
                .refreshable {
                    viewModel.onRefresh()
                }
            }
        }
    }
    
    @ViewBuilder
    private func postsSection() -> some View {
        ForEach(viewModel.posts) { post in
            PostRow(post: post)
                .onAppear {
                    if post.id == viewModel.posts.last?.id && viewModel.hasMore {
                        viewModel.loadMorePosts()
                    }
                }
        }
    }
    
    @ViewBuilder
    private func loadingMoreSection() -> some View {
        if viewModel.isLoadingMore {
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
            viewModel.didTapAddButton()
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
        Button(action: { viewModel.onRefresh() }) {
            Image(systemName: "arrow.clockwise")
        }
        .disabled(viewModel.isLoading)
    }
}
