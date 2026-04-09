//
//  PostDetailViewModel.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 31.03.2026.
//

import Foundation
import Combine

// MARK: - ViewModel protocol
protocol PostDetailViewModelProtocol: ObservableObject {
    var postID: Int { get }
    var post: Post? { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    
    func fetchPostDetails()
    func dismissError()
    func onBack()
}

// MARK: - ViewModel implementation
@MainActor
final class PostDetailViewModel: PostDetailViewModelProtocol {
    @Published private(set) var postID: Int
    @Published private(set) var post: Post?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    private let apiPostsProvider: ApiPostsProvider
    
    init(postID: Int, apiPostsProvider: ApiPostsProvider) {
        self.postID = postID
        self.apiPostsProvider = apiPostsProvider
    }
    
    func fetchPostDetails() {
        isLoading = true
        Task {
            do {
                let post = try await apiPostsProvider.getPost(id: postID)
                handleSuccess(post)
            } catch {
                handleError(error)
            }
        }
    }
    
    @MainActor
    private func handleSuccess(_ result: Post) {
        isLoading = false
        self.post = result
    }
    
    @MainActor
    private func handleError(_ error: Error) {
        isLoading = false
        errorMessage = (error as? ApiError)?.localizedDescription ?? "Failed to load post details"
    }
    
    func dismissError() {
        
    }
    
    func onBack() {
    }
}


