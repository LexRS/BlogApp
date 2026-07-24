//
//  ApiProvider.swift
//  Core
//
//  Created by Алексей Поддубный on 11.07.2026.
//

import Foundation

public protocol ApiProviderProtocol: AnyObject {
    func request<T: Decodable>(_ router: ApiRouter) async throws -> T
}
