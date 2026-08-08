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
    func saveSession(_ session: Session) async
    func clearSession() async
    func refreshToken() async -> String?
}

public enum AuthEvent {
    case sessionExpired
}

final class DefaultSessionProvider: SessionProviderProtocol {
    private let sessionKeeper: SessionKeeperProtocol
    let sessionEvents = PassthroughSubject<AuthEvent, Never>()

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
    
    func saveSession(_ session: Session) async {
        await sessionKeeper.saveSession(session)
    }
    
    func refreshToken() async -> String? {
        await sessionKeeper.refreshToken
    }
    
    func clearSession() async {
        await sessionKeeper.clearSession()
        sessionEvents.send(.sessionExpired)
    }
}

extension DefaultSessionProvider: SessionObserving {
    var isAuthenticatedPublisher: AnyPublisher<Bool, Never> {
        Deferred { [weak self] in
            Future { promise in
                Task {
                    if let result = await self?.sessionKeeper.accessToken {
                        promise(.success(true))
                    } else {
                        promise(.success(false))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
