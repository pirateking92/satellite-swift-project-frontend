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
                    Image("satellite-dish")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .accessibilityIdentifier("satellite-logo")
                    Text("You're one click away \nfrom lift off!")
                        .font(.custom("Futura", size: 20))
                        .foregroundColor(Color(red: 188/255, green: 188/255, blue: 188/255))
                        .multilineTextAlignment(.center)
                }
                    .padding(.bottom, 400)
                VStack {
                    TextField("Enter your email address", text: $newUser.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .padding()
                        .padding(.top, 25)
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
                    .frame(width: 220, height: 50)
                    .background(Color(red: 112/255, green: 132/255, blue: 252/255))
                    .cornerRadius(15.0)
                    .padding(.bottom, 30)
                    .shadow(radius: 1)
                    
                    if let error = loginError {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .navigationDestination(isPresented: $isLoggedIn) {
                    WelcomePageView()}
                .background(Color(red: 156/255, green: 188/255, blue: 252/255))
                .cornerRadius(15.0)
                .padding(45)
                .padding(.top, 75)
                .opacity(0.8)
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
