//
//  Extension+Binding.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 08.07.2026.
//

import SwiftUI

extension Binding where Value == String? {
    var orEmpty: Binding<String> {
        Binding<String>(
            get: { self.wrappedValue ?? "" }, set: { newValue in self.wrappedValue = newValue.isEmpty ? nil : newValue }
        )
    }
}
