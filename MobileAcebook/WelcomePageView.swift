//
//  WelcomePageView.swift
//  MobileAcebook
//
//  Created by Josué Estévez Fernández on 30/09/2023.
//

import SwiftUI
import AVKit

struct WelcomePageView: View {
    @State private var isLoginViewActive = false
    @State private var isSignUpViewActive = false
    @State var player = AVPlayer()
    var videoUrl: String = "https://assets.mixkit.co/videos/preview/mixkit-view-of-the-night-sky-filled-with-stars-39770-large.mp4"


    var body: some View {
        NavigationView {
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
                    Spacer()
                    
                    Text("This is \nSatellite!")
                        .font(.custom("Futura", size: 28))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 188/255, green: 188/255, blue: 188/255))
                        .kerning(3.5)
                        .padding(.bottom, 20)
                        .multilineTextAlignment(.center)
                        .accessibilityIdentifier("welcomeText")
                    Text("Launch your thoughts into orbit")
//                        .font(.title3)
                        .font(.custom("Futura", size: 22))
                        .foregroundColor(Color(red: 188/255, green: 188/255, blue: 188/255))
                    
                        .opacity(0.9)
                        .padding(.bottom, 20)
                        .accessibilityIdentifier("taglineText")
                    
                    Spacer()
                    
                    Image("satellite-dish")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 240, height: 240)
                        
                        .accessibilityIdentifier("satellite-logo")
                    
                    Spacer()
                    
                        NavigationLink(
                            destination: LoginView().transition(.opacity),
                            label: {
                                Text("Login")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 220, height: 50)
                                    .background(Color(red: 112/255, green: 132/255, blue: 252/255))
                                    .cornerRadius(15.0)
                                    .opacity(0.5)
                            }
                        )

                        NavigationLink(
                            destination: SignUpView().transition(.opacity), 
                            label: {
                                Text("New here? Sign up!")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 220, height: 50)
                                    .background(Color(red: 112/255, green: 132/255, blue: 252/255))
                                    .cornerRadius(15.0)
                                    .opacity(0.5)
                            }
                        )
                        .padding()
                    
                
                    
                    Spacer()
                }
            }
            
        }
        .navigationBarHidden(true)
    }
       
}

struct WelcomePageView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePageView()
    }
}
