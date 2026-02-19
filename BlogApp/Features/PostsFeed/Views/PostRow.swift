//
//  PostRow.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 19.02.2026.
//

import SwiftUI

struct PostRow: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(post.title)
                .font(.headline)
                .lineLimit(2)
            
            Text(post.content)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            HStack {
                Text(post.author)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                Text(post.createdAt, format: Date.FormatStyle(date: .abbreviated, time: .shortened).attributedStyle)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.leading, 4)
            }
        }
        .padding(.vertical, 8)
    }
}
