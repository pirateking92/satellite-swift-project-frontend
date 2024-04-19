//
//  FeedPageView.swift
//  MobileAcebook
//
//  Created by Josué Estévez Fernández on 30/09/2023.
//

import SwiftUI
import AVKit


struct FeedPageView: View {
    
    @State var postContent: String = ""
    @State var postList: [Post] = []
    @State var player = AVPlayer()
    var videoUrl: String = "https://assets.mixkit.co/videos/preview/mixkit-view-of-the-night-sky-filled-with-stars-39770-large.mp4"
    let dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "HH:mm 'on' EEEE, MMMM d, yyyy"
           return formatter
       }()
    @AppStorage("user_id") var user_id: String = ""
    
    var body: some View {
        ZStack {
            VideoPlayer(player: player)
                .ignoresSafeArea()
                .onAppear {
                    
                    guard let url = URL(string: videoUrl) else { return }
                    player = AVPlayer(url: url)
                    player.play()
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
                Text("Welcome! What's on your mind?")
                    .font(.custom("Futura", size: 20))
                    .foregroundColor(Color(red: 188/255, green: 188/255, blue: 188/255))
                    .multilineTextAlignment(.center)
                HStack(alignment: .center, spacing: 20) {
                    TextField("Your post is about to take off...", text: $postContent)
                        .font(.system(size: 16))
                        .padding(.bottom, 40)
                    Button(action: {
                        if postContent != "" {
                            createPost(postContent: postContent)
                            postContent = ""
                            //                            THIS ONLY SOMETIMES WORKS BECAUSE OF ASYNC PROBS
                            getAllPosts()
                        }
                    }) {
                        Text("Launch 🚀")
                            .padding(.top, 60)
                            .frame(width: 90, height: 80)
                    }
                    
                
                    
                   
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 20)
                .background(.white)
                .border(Color(red: 112/255, green: 132/255, blue: 225/255), width: 4)
                .cornerRadius(10.0)
                .padding(.horizontal, 20)
                .padding(.top, 40)
                .padding(.bottom, 20)

                
                
                Spacer()
                
                .onAppear {
                    getAllPosts()
                    getUserId()
                }
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(postList.reversed(), id: \._id) { post in
                            GroupBox {
                                HStack {
//                                    here is where the image will go
                                    VStack {
                                        Text(post.createdBy.username)
                                            .font(.headline)
                                            
                                            
                                        Text(formatDate(date: post.createdAt))
                                            .font(.footnote)
                                    }
                                }
                                Text(post.message)
                                    .frame(height: 100)
                                    
                                HStack {
                                    HStack {
//                                      like button
                                        Button(action: {
                                            updateLikes(postID: post._id)
                                            getAllPosts()
                                        })
                                        {HStack {
                                            Image(systemName: post.likes.contains(user_id) ? "heart.fill" : "heart")
                                                .foregroundColor(post.likes.contains(user_id) ? .red : .gray)
                                            Text("\(post.likes.count)")
                                                .foregroundColor(.primary)
                                                .cornerRadius(10)}
                                        }
                                    }
                                    Spacer()
                                    
                                    Text("X comments")
                                        .font(.footnote)
                                        .italic()
                                }

                            }
                           
                            .background(Color(red: 156/255, green: 188/255, blue: 252/255))
                            .border(Color(red: 112/255, green: 132/255, blue: 225/255), width: 4)
                            .cornerRadius(15.0)
                            .padding(.horizontal, 20)

                            
                        }
                    }
                }
            }
        }
    }
    
    func getAllPosts() {
        getPosts { posts, error in
            if let posts = posts {
                self.postList = posts
            } 
            else {
            }
        }
    }
    
    func formatDate(date: String) -> String {
        
//        Format date on post
        let originalDateFormatter = DateFormatter()
        originalDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let postDateTime = originalDateFormatter.date(from: date)!
        
//        get current date
        let currentDateTime = Date()

        var timeInterval = currentDateTime.timeIntervalSince(postDateTime)
        
//        older than a day
        if timeInterval > 86400 {
            dateFormatter.dateFormat = "dd MMMM ''yy"
            let dateString = dateFormatter.string(from: postDateTime)
            return dateString
        }
//        older than an hour
        else if timeInterval > 3600 {
            let hours = Int(round(timeInterval) / 3600)
            if hours == 1 {
                return "posted 1 hour ago"
            }
            else {
                return "posted \(hours) hours ago"
            }
        }
//        older than one min
        else if timeInterval > 60 {
            let mins = Int(round(timeInterval) / 60)
            if mins == 1 {
                return "posted 1 minute ago"
            }
            else {
                return "posted \(mins) mins ago"
            }
        }
        else {
            return "posted just now"
        }
    }

}




struct FeedPageView_Previews: PreviewProvider {
    static var previews: some View {
        FeedPageView()
    }
}
