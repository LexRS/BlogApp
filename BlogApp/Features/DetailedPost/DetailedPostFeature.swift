//
//  Untitled.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 03.03.2026.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DetailedPostFeature {
    @Dependency(\.detailedPostService) var networkService
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.post == nil {
                    return .send(.fetchPost)
                }
                return .none
            case .fetchPost:
                state.isLoading = true
                state.errorMessage = nil
                
                return .run { [postID = state.postID] send in
                    do {
                        let post = try await networkService.fetchPost(postID)
                        await send(.postResponse(.success(post)))
                    } catch let error as ApiError {
                        await send(.postResponse(.failure(error)))
                    } catch {
                        await send(.postResponse(.failure(.networkError(error.localizedDescription))))
                    }
                }
            case .postResponse(.success(let post)):
                state.isLoading = false
                state.post = post
                return .none
            case .postResponse(.failure(let error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
            case .dismissError:
                state.errorMessage = nil
                return .none
            case .backButtonTapped:
                return .run { _ in
                    await self.dismiss()
                }
            }
        }
    }
}

extension DetailedPostFeature {
    @ObservableState
    struct State: Equatable {
        let postID: Int
        var post: Post?
        var isLoading: Bool = false
        var errorMessage: String?
        
        var showErrorAlert: Bool {
            errorMessage != nil
        }
    }
}

extension DetailedPostFeature {
    enum Action: Equatable {
        case onAppear
        case fetchPost
        case postResponse(Result<Post, ApiError>)
        case dismissError
        case backButtonTapped
    }
}
