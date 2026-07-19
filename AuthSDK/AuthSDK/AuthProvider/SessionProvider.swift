//
//  AuthProvider.swift
//  AuthSDK
//
//  Created by Алексей Поддубный on 09.07.2026.
//

import Foundation
import Combine

public protocol SessionProviderProtocol: AnyObject {
    func authorize(_ request: URLRequest) async throws -> URLRequest
}

final class DefaultSessionProvider: SessionProviderProtocol {
    private let sessionKeeper: SessionKeeperProtocol

    init(sessionKeeper: SessionKeeperProtocol) {
        self.sessionKeeper = sessionKeeper
    }

    func authorize(_ request: URLRequest) async throws -> URLRequest {
        guard let token = await sessionKeeper.accessToken else {
            return request
        }

        var request = request
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return request
    }
}
