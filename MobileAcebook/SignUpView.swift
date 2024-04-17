
//
//  AuthenticationService.swift
//  MobileAcebook
//
//  Created by Josué Estévez Fernández on 01/10/2023.
//

import SwiftUI
import AVKit


struct SignUpView: View {
    @State private var newUser: User = User(username: "", password: "", email: "")
    @StateObject private var authentication = AuthenticationService()
    @State private var isSignedUp = false
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
                    TextField("Choose your username", text: $newUser.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .padding()
                    TextField("Add your email address", text: $newUser.email)
                        .background(Color(red: 100, green: 1000, blue: 100))
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
                    .background(Color.gray)
                    .cornerRadius(15.0)
                    .opacity(0.3)
                }
                .navigationDestination(isPresented: $isSignedUp) {LoginView()}
            }
        }
    }
}

#Preview {
    SignUpView()
}
