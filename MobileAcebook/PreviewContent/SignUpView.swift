//
//  SignUpView.swift
//  MobileAcebook
//
//  Created by Oli Kelly on 16/04/2024.
//

import SwiftUI


struct SignUpView: View {
    @State private var newUser: User = User(username: "", password: "", email: "")
    @StateObject private var authentication = AuthenticationService()
    @State private var isSignedUp = false
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Choose your username", text: $newUser.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                TextField("Add your email address", text: $newUser.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                SecureField("Choose your password here", text: $newUser.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                Button(action: {authentication.signUp(user: newUser) {success in
                    if success {
                        isSignedUp = true
                    }
                    else {
                        return
                    }
                }
                })
                {
                    Text("Sign up here")}
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 220, height: 50)
                .background(Color.blue)
                .cornerRadius(15.0)
            }
            .navigationDestination(isPresented: $isSignedUp) {WelcomePageView()}
        }
    }
}

#Preview {
    SignUpView()
}
