//
//  CommentService.swift
//  MobileAcebook
//
//  Created by Matt Doyle on 19/04/2024.
//

import Foundation
import SwiftUI

struct CreateCommentResponse: Codable {
    let message: String
    let token: String
}

func createComment(commentContent: String, postID: String) -> Void {
    // Logic to call the backend API for signing up
    let message = commentContent
    @AppStorage("token") var savedToken: String = ""
    print("savedToken extracted for createPost: \(savedToken)")
    let url = URL(string: "http://localhost:3000/comments/\(postID)")!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("Bearer \(savedToken)", forHTTPHeaderField: "Authorization")
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body: [String: Any] = [
            "message": message
        ]
        
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
    } catch {
        print("Error: no message created")
    }
    

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print(error)
            return
        }
        
        if let responseData = data {
            do {
                let createPostResponse = try JSONDecoder().decode(CreatePostResponse.self, from: responseData)
                UserDefaults.standard.set(createPostResponse.token, forKey: "token")
            } catch {
                print(error)
            }
        } else {
            print(error!)
        }
    }.resume()

}

func getComment(postID: String, completion: @escaping ([Comment]?, Error?) -> Void) {
    
    @AppStorage("token") var savedToken: String = ""
    print("savedToken extracted for getPosts: \(savedToken)")
    
//    create the struct for decoding
    struct ResponseData: Codable {
        var message: String
        var comments: [Comment]
        var token: String
    }
    
//    check URL
    guard let url = URL(string: "http://localhost:3000/comments/\(postID)") else {
        print("Invalid URL")
        return
    }
    
//    create the request and attach the token
    var request = URLRequest(url: url)
    request.setValue("Bearer \(savedToken)", forHTTPHeaderField: "Authorization")
    
    
//    get data
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil, error)
            return
        }
        do {
//            decode
          let commentsResponse = try JSONDecoder().decode(ResponseData.self, from: data)
            UserDefaults.standard.set(commentsResponse.token, forKey: "token")
            completion(commentsResponse.comments, nil)
        } catch {
            print("Decoding error: \(error)")
          completion(nil, error)
        }
    }.resume()

}
