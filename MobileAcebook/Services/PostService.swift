////
////  PostService.swift
////  MobileAcebook
////
////  Created by LIZZY PEDLEY on 16/04/2024.
////
//
import Foundation
import SwiftUI

struct CreatePostResponse: Codable {
    let message: String
    let token: String
}

func createPost(postContent: String) -> Void {
    // Logic to call the backend API for signing up
    let message = postContent
    @AppStorage("token") var savedToken: String = ""
    print("savedToken extracted for createPost: \(savedToken)")
    let url = URL(string: "http://localhost:3000/posts")!
    
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

//func getPosts() -> Void {
//    let url = URL(string: "http://localhost:3000/posts")!
//    let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNjYxZTRmN2EwNTZjMjY2MDE2ZjJjMWIxIiwiaWF0IjoxNzEzMjYyNzQwLCJleHAiOjE3MTM4NjI3NDB9.DTMTjtXdhz8KYv93ai2SEeABo7uUQ5NGXfSEI4i8sRQ"
//    var posts: [Post] = []
//    @Binding var postList: [Post]
//
//    struct ResponseData: Codable {
//        var posts: [Post]
//        var token: String
//    }
//
//    var request = URLRequest(url: url)
//    request.httpMethod = "GET"
//    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//        if let data = data {
//            let decoder = JSONDecoder()
//            do {
//                let responseData = try decoder.decode(ResponseData.self, from: data)
//                posts = responseData.posts
//                let token = responseData.token
//                print("RESPONSE DATA")
//                print(responseData.posts)
//                print("POSTS")
//                print(posts)
//                print("TOKEN")
//                print(token)
//
//            } catch {
//                print("Error decoding response: \(error)")
//            }
//        }
//    }
//    
//    task.resume()
//}


func getPosts(completion: @escaping ([Post]?, Error?) -> Void) {
    
    @AppStorage("token") var savedToken: String = ""
    print("savedToken extracted for getPosts: \(savedToken)")
    
//    create the struct for decoding
    struct ResponseData: Codable {
        var posts: [Post]
        var token: String
    }
    
//    check URL
    guard let url = URL(string: "http://localhost:3000/posts") else {
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
          let postsResponse = try JSONDecoder().decode(ResponseData.self, from: data)
            UserDefaults.standard.set(postsResponse.token, forKey: "token")
            completion(postsResponse.posts, nil)
        } catch {
            print("Decoding error: \(error)")
          completion(nil, error)
        }
    }.resume()

}



//typealias PostCallback = (String?, Error?) -> Void
//
//// Function to fetch a joke.
//// The function takes a completion block as a parameter.
//func getPosts(completion: @escaping PostCallback) {
//    // @escaping means the closure can outlive the function call.
//
//    // Construct the URL for the joke API.
//    let urlString = "http://localhost:3000/posts"
//    let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNjYxZTRmN2EwNTZjMjY2MDE2ZjJjMWIxIiwiaWF0IjoxNzEzMjYyNzQwLCJleHAiOjE3MTM4NjI3NDB9.DTMTjtXdhz8KYv93ai2SEeABo7uUQ5NGXfSEI4i8sRQ"
//    
//    guard let url = URL(string: urlString) else {
//        // If the URL is invalid, call the completion block with an error.
//        completion(nil, NSError(domain: "Invalid URL", code: 400, userInfo: nil))
//        return
//    }
//    
//    
//
//    // Create a URLSession data task to fetch data from the URL.
//    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//        // This block is executed once the data is fetched.
//
//        // Check if there was an error in the data task.
//        if let error = error {
//            // Call the completion block with the error.
//            completion(nil, error)
//            return
//        }
//
//        // Parse the fetched data to a String.
//        if let data = data, let postsJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//           let posts = postsJSON["setup"] as? String, let punchline = postsJSON["punchline"] as? String {
//            // Call the completion block with the joke.
//            completion("\(joke) - \(punchline)", nil)
//        } else {
//            // If data parsing fails, call the completion block with an error.
//            completion(nil, NSError(domain: "Invalid data", code: 500, userInfo: nil))
//        }
//    }
//
//    // Start the data task.
//    task.resume()
//}

func updateLikes(postID: String) -> Void {
        // Logic to call the backend API for signing up
        @AppStorage("token") var savedToken: String = ""
        let url = URL(string: "http://localhost:3000/posts")!
        
        struct ResponseData: Codable {
            var post: Likes
            var token: String
            var message: String
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(savedToken)", forHTTPHeaderField: "Authorization")
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "postId": postID
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
                    let likesResponse = try JSONDecoder().decode(ResponseData.self, from: responseData)
                    let likes = likesResponse.post.likes
                    UserDefaults.standard.set(likesResponse.token, forKey: "token")
                    print(likes)
                } catch {
                    print(error)
                }
            } else {
                print(error!)
            }
        }.resume()
        
    }

func getUserId() -> Void {
    @AppStorage("token") var savedToken: String = ""
    print("savedToken extracted for getPosts: \(savedToken)")
    
    //    create the struct for decoding
    struct ResponseData: Codable {
        var userData: [UserData]
        var token: String
    }
    guard let url = URL(string: "http://localhost:3000/users") else {
        print("Invalid URL")
        return
    }
    
    //    create the request and attach the token
    var request = URLRequest(url: url)
    request.setValue("Bearer \(savedToken)", forHTTPHeaderField: "Authorization")
    
    
    //    get data
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            return
        }
        do {
            //            decode
            let userResponse = try JSONDecoder().decode(ResponseData.self, from: data)
            UserDefaults.standard.set(userResponse.token, forKey: "token")
            let user_id = userResponse.userData[0]._id
            UserDefaults.standard.set(user_id, forKey: "user_id")
        } catch {
            print("Decoding error: \(error)")
        }
    }.resume()
}
    
//}
