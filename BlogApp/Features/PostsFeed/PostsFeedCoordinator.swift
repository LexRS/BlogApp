//
//  PostsFeedCoordinator.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 30.03.2026.
//

import SwiftUI
import Combine

protocol PostsFeedCoordinatorProtocol: AnyObject {
    func showPostDetails(_ post: Post)
    func showCreatePost(completion: @escaping (Post?) -> Void)
}

final class PostsFeedCoordinator: ObservableObject, PostsFeedCoordinatorProtocol {
    weak var parentCoordinator: AppCoordinator?
    
    @Published var navigationPath = NavigationPath()
    @Published var presentedPost: Post?
    @Published var isCreatePostPresented = false
    
    private var createPostCompletion: ((Post?) -> Void)?
    
    func showPostDetails(_ post: Post) {
        presentedPost = post
    }
    
    func showCreatePost(completion: @escaping (Post?) -> Void) {
        createPostCompletion = completion
        isCreatePostPresented = true
    }
    
//    @ViewBuilder
//    func buildPostDetailsView(for post: Post) -> some View {
//        PostDetailsView(
//            viewModel: PostDetailsViewModel(
//                post: post,
//                apiService: APIService(),
//                coordinator: PostDetailsCoordinator()
//            )
//        )
//    }
    
//    @ViewBuilder
//    func buildCreatePostView() -> some View {
//        CreatePostView(
//            viewModel: CreatePostViewModel(apiService: APIService())
//        ) { [weak self] newPost in
//            self?.createPostCompletion?(newPost)
//            self?.isCreatePostPresented = false
//        }
//    }
}
