
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
                Image("satellite-dish")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .accessibilityIdentifier("satellite-logo")
                Text("Join the Satellite community\n and soar to new heights!")
                    .font(.custom("Futura", size: 20))
                    .foregroundColor(Color(red: 188/255, green: 188/255, blue: 188/255))
                    .multilineTextAlignment(.center)
            }
            
            .padding(.bottom, 400)
            
            VStack {
                TextField("Choose your username", text: $newUser.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                    .padding(.top, 25)
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
                }) {
                Text("Sign up here")}
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 220, height: 50)
                .border(Color(red: 112/255, green: 132/255, blue: 225/255), width: 1)
                .background(Color(red: 112/255, green: 132/255, blue: 252/255))
                .cornerRadius(15.0)
                .padding(.bottom, 30)
                .shadow(radius: 5)
                
                

            }
            
            
            .navigationDestination(isPresented: $isSignedUp) {LoginView()}
            .background(Color(red: 156/255, green: 188/255, blue: 252/255))
            .cornerRadius(15.0)
            .padding(50)
            .padding(.top, 150)
            .opacity(0.8)
        }
        
        
    }
            }
        }
    

#Preview {
    SignUpView()
}
