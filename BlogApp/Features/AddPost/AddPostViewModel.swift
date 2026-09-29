//
//  AddPostViewModel.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 06.08.2026.
//

import SwiftUI
import Combine

protocol AddPostViewModelProtocol: ObservableObject {
    var title: String { get set }
    var bodyText: String { get set }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    func uploadPost()
    func dismissError()
    func onBack()
}

@MainActor
final class AddPostViewModel: AddPostViewModelProtocol {
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    @State var title: String = ""
    @State var bodyText: String = ""
    
    private let apiPostsProvider: ApiPostsProviderProtocol
    
    init(apiPostsProvider: ApiPostsProviderProtocol) {
        self.apiPostsProvider = apiPostsProvider
    }
    
    func uploadPost() {
        let createPostRequest = CreatePostRequest(title: title, content: bodyText, author: "It's me")
        isLoading = true
        Task {
            do {
                let response = try await apiPostsProvider.createPost(createPostRequest)
                handleSuccess(response)
            } catch {
                handleFailure(error)
            }
        }
    }
    
    func dismissError() {
    }
    
    func onBack() {
    }
    
    private func handleSuccess(_ postResponse: Post) {
        
    }
    
    private func handleFailure(_ error: Error) {
        
    }
}
