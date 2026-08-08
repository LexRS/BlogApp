//
//  AddPostView.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 06.08.2026.
//

import SwiftUI

struct AddPostView: View {
    @EnvironmentObject var viewModel: AddPostViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Post details")) {
                TextField("Enter title", text: $viewModel.title)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                
                ZStack(alignment: .topLeading) {
                    if viewModel.bodyText.isEmpty {
                        Text("Enter body content...")
                    }
                    TextEditor(text: $viewModel.bodyText)
                        .frame(minHeight: 150)
                        .padding(4)
                }
            }
            
            Section {
                Button(action: viewModel.uploadPost) {
                    Text("Submit post")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .disabled(viewModel.title.isEmpty || viewModel.bodyText.isEmpty)
            }
        }
    }
}
