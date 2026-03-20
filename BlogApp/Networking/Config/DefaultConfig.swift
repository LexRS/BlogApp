//
//  DefaultConfig.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 06.03.2026.
//

import Foundation

struct DefaultConfig: Config {
    var baseUrl: String {
        let baseUrlScheme: String = info(.apiBaseUrlScheme)
        let baseDomain: String = info(.apiBaseUrl)
        return baseUrlScheme + "://" + baseDomain
    }
}

private extension DefaultConfig {
    func info<T>(_ key: Key) -> T {
        guard let dict = Bundle.main.infoDictionary, let result = dict[key.rawValue] as? T else {
            fatalError("no \(key.rawValue) in info.plist of type: \(T.self)")
        }
        return result
    }
    
    enum Key: String {
        case apiBaseUrl = "API_BASE_URL"
        case apiBaseUrlScheme = "API_BASE_URL_SCHEME"
    }
}
