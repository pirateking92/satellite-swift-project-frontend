//
//  FeedPageView.swift
//  MobileAcebook
//
//  Created by Josué Estévez Fernández on 30/09/2023.
//

import SwiftUI

struct FeedPageView: View {
    
    @State var postContent: String = ""
    @State var postList: [Post] = []
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    TextField("Add your post:", text: $postContent)
                    Button(action: {
                        if postContent != "" {
                            createPost(postContent: postContent)
                            postContent = ""
//                            THIS ONLY SOMETIMES WORKS BECAUSE OF ASYNC PROBS
                            getAllPosts()
                        }
                    }) {
                        Text("Post")
                    }
                }
                .padding(20)
                
                Spacer()
                
                .onAppear {
                    getAllPosts()
                }
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(postList, id: \.message) { post in
                            GroupBox {
                                HStack {
//                                    here is where the image will go
                                    VStack {
                                        Text(post.createdBy.username)
                                        Text(post.createdAt)
                                            .font(.footnote)
                                    }
                                }
                                Text(post.message)
                                    .frame(height: 100)
                                HStack {
                                    HStack {
//                                      like button
//                                        Text("\(post.likes.count)")
                                        Text("X likes")
                                            .font(.footnote)
                                            .italic()
                                    }
                                    Spacer()
                                    
                                    Text("X comments")
                                        .font(.footnote)
                                        .italic()
                                }

                            }
                            .backgroundStyle(Color.white)
                            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
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
}



struct FeedPageView_Previews: PreviewProvider {
    static var previews: some View {
        FeedPageView()
    }
}
