//
//  PostsFeedViewModel.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 30.03.2026.
//

import SwiftUI
import Combine

// MARK: - ViewModel Protocol
protocol PostsFeedViewModelProtocol: ObservableObject {
    var posts: [Post] { get }
    var isLoading: Bool { get }
    var isLoadingMore: Bool { get }
    var errorMessage: String? { get }
    var hasMore: Bool { get }
    
    func onAppear()
    func didSelectPost(_ post: Post)
    func didTapAddButton()
    func onRefresh()
    func loadMorePosts()
    func dismissError()
}

// MARK: - ViewModel Implementation
@MainActor
final class PostsFeedViewModel: PostsFeedViewModelProtocol {
    @Published private(set) var posts: [Post] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isLoadingMore = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var hasMore = true
    
    private let apiPostsProvider: ApiPostsProvider
    private let coordinator: PostsFeedCoordinatorProtocol
    private var currentCursor: String?
    
    init(apiPostsProvider: ApiPostsProvider, coordinator: PostsFeedCoordinatorProtocol) {
        self.apiPostsProvider = apiPostsProvider
        self.coordinator = coordinator
    }
    
    func onAppear() {
        if posts.isEmpty {
            fetchPosts()
        }
    }
    
    func didSelectPost(_ post: Post) {
        coordinator.showPostDetails(post)
    }
    
    func didTapAddButton() {
        coordinator.showCreatePost { [weak self] newPost in
            if let newPost = newPost {
                self?.posts.insert(newPost, at: 0)
            }
        }
    }
    
    func onRefresh() {
        guard !isLoading else { return }
        fetchPosts()
    }
    
    func loadMorePosts() {
        guard !isLoadingMore, hasMore else { return }
        fetchMorePosts()
    }
    
    func dismissError() {
        errorMessage = nil
    }
    
    // MARK: - Private Methods
    private func fetchPosts() {
        isLoading = true
        errorMessage = nil
        posts = []
        currentCursor = nil
        
        Task {
            do {
                let response = try await apiPostsProvider.getPosts(cursor: nil)
                handleSuccess(response)
            } catch {
                handleError(error)
            }
        }
    }
    
    private func fetchMorePosts() {
        isLoadingMore = true
        
        Task {
            do {
                let response = try await apiPostsProvider.getPosts(cursor: currentCursor)
                handleMoreSuccess(response)
            } catch {
                handleError(error)
            }
        }
    }
    
    @MainActor
    private func handleSuccess(_ response: PostsResponse) {
        isLoading = false
        posts = response.posts
        currentCursor = response.nextCursor
        hasMore = response.hasMore
    }
    
    @MainActor
    private func handleMoreSuccess(_ response: PostsResponse) {
        isLoadingMore = false
        posts.append(contentsOf: response.posts)
        currentCursor = response.nextCursor
        hasMore = response.hasMore
    }
    
    @MainActor
    private func handleError(_ error: Error) {
        isLoading = false
        isLoadingMore = false
        errorMessage = (error as? ApiError)?.localizedDescription ?? "Failed to load posts"
    }
}
