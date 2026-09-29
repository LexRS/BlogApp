//
//  EnvironmentDependencies.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 29.09.2026.
//

import SwiftUI

private struct ViewModelFactoryKey: EnvironmentKey {
    static let defaultValue: ViewModelFactory = ViewModelFactory(appServices: AppServices())
}

extension EnvironmentValues {
    var viewModelFactory: ViewModelFactory {
        get {
            self[ViewModelFactoryKey.self]
        }
        set {
            self[ViewModelFactoryKey.self] = newValue
        }
    }
}
