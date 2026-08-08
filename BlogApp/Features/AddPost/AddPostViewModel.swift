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
    
    private let apiPostProvider: ApiPostsProviderProtocol
    
    init(apiPostProvider: ApiPostsProviderProtocol) {
        self.apiPostProvider = apiPostProvider
    }
    
    func uploadPost() {
    }
    
    func dismissError() {
    }
    
    func onBack() {
    }
}
