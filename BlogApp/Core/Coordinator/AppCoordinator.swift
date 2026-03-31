//
//  AppCoordinator.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 30.03.2026.
//

import UIKit
import Combine
import SwiftUI

final class AppCoordinator: ObservableObject {
    private let container: Dependencies
    @Published var path = NavigationPath()
    
    init(container: Dependencies) {
        self.container = container
    }
    
    @ViewBuilder
    func makeRootView() -> some View {
        showPostsFeed()
    }
    
    private func showPostsFeed() -> some View {
        let postsFeedViewModel = container.getPostsFeedViewModel()
        return PostsFeedView(viewModel: postsFeedViewModel)
    }
}
