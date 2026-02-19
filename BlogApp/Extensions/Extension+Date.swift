//
//  Date+Extension.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 17.02.2026.
//

import Foundation

extension Date {
    func postDescFormatted() -> String {
        self.formatted(date: .abbreviated, time: .shortened)
    }
}
