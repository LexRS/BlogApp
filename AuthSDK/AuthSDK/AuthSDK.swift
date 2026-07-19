//
//  AuthSDK.swift
//  AuthSDK
//
//  Created by Алексей Поддубный on 03.07.2026.
//

import Foundation
import Combine

public class AuthAssembly {
    // The public interface - only this should be visible to the app
    public static func buildSessionProvider() -> SessionProviderProtocol {
        // Internal assembly - App doesn't need to know these details
        let sessionKeeper = DefaultSessionKeeper()
        return DefaultSessionProvider(sessionKeeper: sessionKeeper)
    }
}

