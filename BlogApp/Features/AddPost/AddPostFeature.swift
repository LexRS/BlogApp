//
//  AddPostFeature.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 24.02.2026.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AddPostFeature {
    @Dependency(\.addPostService) var networkService
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .saveButtonTapped:
                guard state.isValid else { return .none }
                
                state.isSaving = true
                state.errorMessage = nil
                
                let post = CreatePostRequest(
                    title: state.title,
                    content: state.content,
                    author: state.author
                )
                
                return .run { send in
                    do {
                        let newPost = try await networkService.createPost(post)
                        await send(.saveResponse(.success(newPost)))
                    } catch let error as ApiError {
                        await send(.saveResponse(.failure(error)))
                    } catch {
                        await send(.saveResponse(.failure(.networkError(error.localizedDescription))))
                    }
                }
                
            case .cancelButtonTapped:
                return .run { _ in
                    await self.dismiss()
                }
                
            case .saveResponse(.success):
                state.isSaving = false
                return .run { _ in
                    await self.dismiss()
                }
                
            case let .saveResponse(.failure(error)):
                state.isSaving = false
                state.errorMessage = error.localizedDescription
                return .none
                
            case .dismiss:
                return .run { _ in
                    await self.dismiss()
                }
            }
        }
    }
}

// MARK: - State
extension AddPostFeature {
    @ObservableState
    struct State: Equatable {
        var title = ""
        var content = ""
        var author = ""
        var isSaving = false
        var errorMessage: String?
        
        var isValid: Bool {
            !title.isEmpty && !content.isEmpty && !author.isEmpty
        }
    }
}

// MARK: - Actions
extension AddPostFeature {
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case saveButtonTapped
        case cancelButtonTapped
        case saveResponse(Result<Post, ApiError>)
        case dismiss
    }
}

