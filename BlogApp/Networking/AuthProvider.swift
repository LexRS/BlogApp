//
//  AuthProvider.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 07.03.2026.
//

import Foundation

protocol AuthProvider {
    func authorize(_ request: URLRequest) async throws -> URLRequest
}

final class DefaultAuthProvider: AuthProvider {

    private let sessionKeeper: SessionKeeper

    init(sessionKeeper: SessionKeeper) {
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
