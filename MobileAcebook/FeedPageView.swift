//
//  FeedPageView.swift
//  MobileAcebook
//
//  Created by Josué Estévez Fernández on 30/09/2023.
//

import SwiftUI

struct FeedPageView: View {
    
    @State var postContent: String = ""
//    @State var postList: [Post] = []
    @State var postList: [Post] = []
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    TextField("Add your post:", text: $postContent)
                    Button(action: {
                        createPost(postContent: postContent)
                    }) {
                        Text("Post")
                    }
                }
                
                Spacer()
                
                Button(action: {
                    getPosts()
                }) {
                    Text("Get posts")
                }
                
                ForEach(postList, id: \.message) { post in
                    GroupBox {
                        Text(post.createdBy.username)
                            .font(.footnote)
                        Text(post.message)
                        .frame(width: 300, height: 100)
                    }
                }
            
                }
            }
        }
    }



struct FeedPageView_Previews: PreviewProvider {
    static var previews: some View {
        FeedPageView()
    }
}
