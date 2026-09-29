//
//  SessionObserving.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 07.08.2026.
//

import Combine

public protocol SessionObserving {
    var isAuthenticatedPublisher: AnyPublisher<Bool, Never> { get }
}
