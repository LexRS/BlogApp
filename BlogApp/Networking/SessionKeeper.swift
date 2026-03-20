//
//  SessionKeeper.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 07.03.2026.
//

import Foundation

protocol SessionKeeper: Actor {
    var accessToken: String? { get async }
    var refreshToken: String? { get async }
    func saveSession(_ session: Session) async
    func clearSession() async
}

struct Session: Sendable {
    var accessToken: String
    var refreshToken: String
}

actor DefaultSessionKeeper: SessionKeeper {
    private let storage: KeychainStorageProtocol
    
    init(storage: KeychainStorageProtocol = KeychainStorage()) {
        self.storage = storage
    }
    
    var accessToken: String? {
        get async {
            await MainActor.run {
                storage.get(KeychainKey.accessToken)
            }
        }
    }
    
    var refreshToken: String? {
        get async {
            await MainActor.run {
                storage.get(KeychainKey.refreshToken)
            }
        }
    }
    
    func saveSession(_ session: Session) async {
        await MainActor.run {
            storage.set(session.accessToken, for: KeychainKey.accessToken)
            storage.set(session.refreshToken, for: KeychainKey.refreshToken)
        }
    }

    func clearSession() async {
        await MainActor.run {
            storage.remove(KeychainKey.accessToken)
            storage.remove(KeychainKey.refreshToken)
        }
    }
    
    static func create() async -> DefaultSessionKeeper {
        await DefaultSessionKeeper(storage: KeychainStorage())
    }
}

