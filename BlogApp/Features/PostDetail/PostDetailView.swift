//
//  PostDetailView.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 31.03.2026.
//

import SwiftUI

struct PostDetailView: View {
    @StateObject var viewModel: PostDetailViewModel
    @EnvironmentObject var coordinator: AppCoordinator
    @Environment(\.dismiss) var dismiss
    
    private var id: Int
    
    init(viewModel: PostDetailViewModel, id: Int) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.id = id
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Post Content
                if let post = viewModel.post {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(post.author)
                                .font(.headline)
                            Spacer()
                            Text(post.createdAt, style: .date)
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                        }
                        Text(post.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text(post.content)
                            .font(.body)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                }
            }
        }
        .navigationTitle("Post Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                dismiss() 
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .onAppear {
            viewModel.fetchPostDetails(with: id)
        }
    }
}

