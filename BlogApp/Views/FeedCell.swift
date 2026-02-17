//
//  FeedCell.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 17.02.2026.
//

import SwiftUI

struct FeedCell: View {
    var post: Post
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(post.author)
                    .fontWeight(.semibold)
                    .padding(.leading, 10)
                Text("published")
                Text(post.createdAt.postDescFormatted())
            }
            Divider()
            Text(post.title)
                .padding(.leading, 10)
                .padding(.top, 1)
            Text(post.content)
                .padding(.leading, 10)
                .padding(.top, 1)
                .foregroundColor(.gray)
        }
        .font(.footnote)
    }
}

#Preview {
    FeedCell(post: Post.MOCK_POSTS[0])
}
