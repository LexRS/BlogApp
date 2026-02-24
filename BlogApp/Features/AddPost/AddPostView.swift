//
//  AddPostView.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 24.02.2026.
//

import SwiftUI
import ComposableArchitecture

struct AddPostView: View {
    @Bindable var store: StoreOf<AddPostFeature>
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Post Details") {
                    TextField("Title", text: $store.title)
                        .textInputAutocapitalization(.words)
                    
                    TextField("Author", text: $store.author)
                        .textInputAutocapitalization(.words)
                    
                    TextField("Content", text: $store.content, axis: .vertical)
                        .lineLimit(5...10)
                }
                
                if let error = store.errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        store.send(.cancelButtonTapped)
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        store.send(.saveButtonTapped)
                    }
                    .disabled(!store.isValid || store.isSaving)
                }
            }
            .overlay {
                if store.isSaving {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.1))
                }
            }
        }
    }
}
