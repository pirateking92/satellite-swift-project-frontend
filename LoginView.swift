//
//  LoginView.swift
//  MobileAcebook
//
//  Created by Oli Kelly on 16/04/2024.
//

import SwiftUI


struct LoginView: View {
    @State private var newUser: User = User(username: "", password: "", email: "")
    @StateObject private var authentication = AuthenticationService()
    @State private var isLoggedIn = false
    @State private var loginError: String?
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Add your details here to login")
                TextField("Enter your email address", text: $newUser.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                SecureField("Enter your password here", text: $newUser.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                Button(action: {
                    login()
                }) {
                    Text("Login")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 220, height: 50)
                .background(Color.blue)
                .cornerRadius(15.0)

                if let error = loginError {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                WelcomePageView()
            }
        }
    }

    private func login() {
        authentication.login(user: newUser) { result in
            switch result {
            case .success(let loginResponse):
                isLoggedIn = true
                print("Message: \(loginResponse.message)")
                print("Token: \(loginResponse.token)")
                print("\(loginResponse.token)")
            case .failure(let error):
                loginError = error.localizedDescription
            }
        }
    }
}

#Preview {
    LoginView()
}
