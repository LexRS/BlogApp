//
//  ViewModelFactory.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 26.09.2026.
//

@MainActor
final class ViewModelFactory {
    private let appServices: AppServices
    
    init(appServices: AppServices) {
        self.appServices = appServices
    }
    
    func makeRegistrationViewModel() -> RegistrationViewModel {
        let authProvider = appServices.authProvider
        return RegistrationViewModel(authProvider: authProvider)
    }
    
    func makePostsFeedViewModel() -> PostsFeedViewModel {
        let apiPostsProvider = appServices.apiPostsProvider
        return PostsFeedViewModel(apiPostsProvider: apiPostsProvider)
    }
    
    func makeAddPostViewModel() -> AddPostViewModel {
        let apiPostsProvider = appServices.apiPostsProvider
        return AddPostViewModel(apiPostsProvider: apiPostsProvider)
    }
    
    func makePostDetailViewModel() -> PostDetailViewModel {
        let apiPostsProvider = appServices.apiPostsProvider
        return PostDetailViewModel(apiPostsProvider: apiPostsProvider)
    }
}
