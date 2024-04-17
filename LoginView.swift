//
//  LoginView.swift
//  MobileAcebook
//
//  Created by Oli Kelly on 16/04/2024.
//

import SwiftUI
import AVKit


struct LoginView: View {
    
    @State private var newUser: User = User(username: "", password: "", email: "")
    @StateObject private var authentication = AuthenticationService()
    @State private var isLoggedIn = false
    @State private var loginError: String?
    @State var player = AVPlayer()
    var videoUrl: String = "https://assets.mixkit.co/videos/preview/mixkit-view-of-the-night-sky-filled-with-stars-39770-large.mp4"
    
    var body: some View {
        NavigationStack {
            ZStack {
                VideoPlayer(player: player)
                    .ignoresSafeArea()
                    .onAppear {
                        
                        guard let url = URL(string: videoUrl) else { return }
                        player = AVPlayer(url: url)
                        player.play()
                        
                        // Loop the video when it ends
                        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { _ in
                            player.seek(to: .zero)
                            player.play()
                        }
                    }
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
                    .background(Color.gray)
                    .cornerRadius(15.0)
                    .opacity(0.3)
                    
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
    }
        
        func login() {
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
