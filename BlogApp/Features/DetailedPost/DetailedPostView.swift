//
//  DetailedPostView.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 03.03.2026.
//

import ComposableArchitecture
import SwiftUI

struct DetailedPostView: View {
    @Perception.Bindable var store: StoreOf<DetailedPostFeature>
    
    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if store.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                    } else if let post = store.post {
                        VStack {
                            Text(post.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .foregroundStyle(.blue)
                                Text(post.author)
                                    .font(.headline)
                                Spacer()
                            }
                            HStack {
                                Label(post.createdAt.formatted(), systemImage: "calendar")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("•")
                                    .foregroundColor(.secondary)
                                Label("Updated \(post.updatedAt.formatted())", systemImage: "pencil")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                            }
                        }
                        .padding(.horizontal)
                            
                        Divider()
                        // Content
                        Text(post.content)
                            .font(.body)
                            .lineSpacing(8)
                            .padding(.horizontal)
                        
                        Spacer(minLength: 40)
                    }
                }
                // Footer
                HStack {
                    Spacer()
                    VStack(spacing: 4) {
                        Image(systemName: "quote.bubble")
                            .font(.largeTitle)
                            .foregroundColor(.blue.opacity(0.3))
                        Text("End of article")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding(.vertical)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                store.send(.onAppear)
            }
            .alert(
                "Error",
                isPresented: Binding(
                    get: { store.showErrorAlert },
                    set: { if !$0 { store.send(.dismissError) } }
                )
            ) {
                Button("OK") {
                    store.send(.dismissError)
                }
            }
            message: {
                if let error = store.errorMessage {
                    Text(error)
                }
            }
        }
    }
}
