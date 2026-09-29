//
//  AddPostView.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 06.08.2026.
//

import SwiftUI

struct AddPostView: View {
    @StateObject var viewModel: AddPostViewModel
    
    init(viewModel: AddPostViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Form {
            Section(header: Text("New post")) {
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
