// Features/PostsFeed/PostsFeedFeature.swift
import Foundation
import ComposableArchitecture

@Reducer
struct PostsFeedFeature {
    @Dependency(\.apiClient) var apiClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.posts.isEmpty {
                    return .send(.fetchPosts)
                }
                return .none
            case .fetchPosts:
                state.isLoading = true
                state.errorMessage = nil
                state.posts = []
                state.nextCursor = nil
                state.hasMore = true
                
                return .run { send in
                    do {
                        let response = try await apiClient.fetchPosts(nil)
                        await send(.postsResponse(.success(response)))
                    } catch let error as ApiError {
                        await send(.postsResponse(.failure(error)))
                    } catch {
                        // Handle unexpected errors
                        await send(.postsResponse(.failure(.networkError(error.localizedDescription))))
                    }
                }
            case .fetchMorePosts:
                guard !state.isLoadingMore, state.hasMore else {
                    return .none
                }
                
                state.isLoadingMore = true
                
                return .run { [cursor = state.nextCursor] send in
                    do {
                        let response = try await apiClient.fetchPosts(cursor)
                        await send(.postsResponse(.success(response)))
                    } catch let error as ApiError {
                        await send(.postsResponse(.failure(error)))
                    } catch {
                        await send(.postsResponse(.failure(.networkError(error.localizedDescription))))
                    }
                }
                
            case let .postsResponse(.success(response)):
                state.isLoading = false
                state.isLoadingMore = false
                state.posts.append(contentsOf: response.posts)
                state.nextCursor = response.nextCursor
                state.hasMore = response.hasMore
                return .none
                
            case let .postsResponse(.failure(error)):
                state.isLoading = false
                state.isLoadingMore = false
                state.errorMessage = error.localizedDescription
                return .none
                
            case .dismissError:
                state.errorMessage = nil
                return .none
            }
        }
    }
}

// MARK: - State
extension PostsFeedFeature {
    @ObservableState
    struct State: Equatable {
        var posts: IdentifiedArrayOf<Post> = []
        var isLoading = false
        var isLoadingMore = false
        var errorMessage: String?
        var nextCursor: String?
        var hasMore = true
        
        var showErrorAlert: Bool {
            errorMessage != nil
        }
    }
}

// MARK: - Action
extension PostsFeedFeature {
    enum Action: Equatable {
        case onAppear
        case fetchPosts
        case fetchMorePosts
        case postsResponse(Result<PostsResponse, ApiError>)
        case dismissError
    }
}
