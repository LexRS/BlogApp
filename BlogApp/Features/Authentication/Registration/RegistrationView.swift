//
//  RegistrationView.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 03.07.2026.
//

import SwiftUI
import AuthSDK

struct RegistrationView: View {
    @StateObject private var viewModel: RegistrationViewModel
    @State private var currentIndex = 0
    @State private var animateMove = false
    
    let manager = AuthenticationManager()
    
    init(viewModel: RegistrationViewModel, currentIndex: Int = 0, animateMove: Bool = false) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.currentIndex = currentIndex
        self.animateMove = animateMove
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            TabView(selection: $currentIndex) {
                ForEach(0..<viewModel.screenNames.count, id: \.self) { index in
                    // Design your individual container layout here
                    CardView(
                        name: viewModel.screenNames[index].name,
                        email: $viewModel.email,
                        password: $viewModel.password,
                        buttonTitle: viewModel.screenNames[index].buttonTitle
                    )
                        .tag(index) // Essential for linking the page to the picker state
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never)) // Hides native page dots layout
            .frame(height: 200)
            
            Spacer()
            
            Picker("What is your favorite color", selection: $currentIndex) {
                Text("Login").tag(0)
                Text("Registration").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal,40)
            .onChange(of: currentIndex) { oldValue, newValue in
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    if newValue == 1 {
                        animateMove = true
                    } else {
                        animateMove = false
                    }
                }
            }
        }
    }
}

// Example design for the view containers inside the paging layout
struct CardView: View {
    let name: String
    @Binding var email: String
    @Binding var password: String
    var buttonTitle: String
    
    var body: some View {
        VStack(spacing: 12) {
            Text("\(name)")
                .font(.system(.title3))
                .foregroundStyle(.white)
            
            TextField("E-mail", text: $email)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 20)
            TextField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 20)
            
            
            Text("Completely replaces the previous screen.")
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            
            Button("\(buttonTitle)") {
                print("\(buttonTitle)")
            }
            .font(.subheadline)
            .foregroundColor(.white)
            .frame(width: 140)
            .background(name == "Registration" ? .purple : .blue)
            .cornerRadius(12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(name == "Registration" ? .blue : .purple)
        .cornerRadius(24)
        .padding(.horizontal, 20) // Gives a beautiful card layout effect
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}


#Preview {
    let model = RegistrationViewModel()
    return RegistrationView(viewModel: model)
}
