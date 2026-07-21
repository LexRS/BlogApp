//
//  RegistrationView.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 03.07.2026.
//

import SwiftUI
import AuthSDK

struct RegistrationView: View {
    @EnvironmentObject private var viewModel: RegistrationViewModel
    @EnvironmentObject private var coordinator: AppCoordinator
    
    @State private var currentIndex = 0
    @State private var animateMove = false
    
    var body: some View {
        VStack {
            Spacer()
            
            TabView(selection: $currentIndex) {
                ForEach(0..<viewModel.screenNames.count, id: \.self) { index in
                    CardView(viewModel: viewModel, index: index)
                        .tag(index) // Essential for linking the page to the picker state
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            Spacer()
            
            Picker("What is your favorite color", selection: $currentIndex) {
                Text(viewModel.screenNames[0].name).tag(0)
                Text(viewModel.screenNames[1].name).tag(1)
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
        .onChange(of: viewModel.isAuthorized) { _, isAuthorized in
            if isAuthorized { // 👈 Проверяем новое пришедшее значение
                coordinator.showMainFlow()
            }
        }
    }
}

struct CardView: View {
    @ObservedObject var viewModel: RegistrationViewModel
    let index: Int
    
    var body: some View {
        VStack(spacing: 12) {
            Text("\(viewModel.screenNames[index].name)")
                .font(.system(.title3))
                .foregroundStyle(.white)
            
            if viewModel.screenNames[index].name == "Registration" {
                TextField("Username", text: $viewModel.userName.orEmpty)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 20)
                    .textInputAutocapitalization(.never)
            }
            TextField("E-mail", text: $viewModel.email)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 20)
                .textInputAutocapitalization(.never)
            TextField("Password", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 20)
                .textInputAutocapitalization(.never)
            
            if viewModel.screenNames[index].name == "Registration" {
                Text("Username should have min 3 max 50 chars. Password at least 6 chars")
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Button("\(viewModel.screenNames[index].buttonTitle)") {
                if viewModel.screenNames[index].name == "Registration" {
                    viewModel.registerButtonTapped()
                } else {
                    viewModel.loginButtonTapped()
                }
            }
            .font(.subheadline)
            .foregroundColor(.white)
            .frame(width: 140, height: 30)
            .background(viewModel.screenNames[index].name == "Registration" ? .purple : .blue)
            .cornerRadius(12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(viewModel.screenNames[index].name == "Registration" ? .blue : .purple)
        .cornerRadius(24)
        .padding(.horizontal, 20) // Gives a beautiful card layout effect
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}


#Preview {
    RegistrationView()
}
