//
//  AuthenticationService.swift
//  MobileAcebook
//
//  Created by Josué Estévez Fernández on 01/10/2023.
//

import Foundation

class AuthenticationService: AuthenticationServiceProtocol, ObservableObject {
    
    func signUp(user: User, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://localhost:3000/users") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let userData: [String: Any] = [
            "email": user.email,
            "username": user.username,
            "password": user.password
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userData, options: [])
            request.httpBody = jsonData
        } catch {
            completion(false)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 201 {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }.resume()
    }
    
    func login(user: User, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "http://localhost:3000/tokens") else {
            completion(false, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let userData: [String: Any] = [
            "email": user.email,
            "username": user.username,
            "password": user.password
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userData, options: [])
            request.httpBody = jsonData
            
        } catch {
            completion(false, nil)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 201 {
                    if let responseData = data,
                       let json = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                       let token = json["token"] as? String {
                        completion(true, token)
                    } else {
                        completion(false, nil)
                    }
                    
                }
            }
        }.resume()
    }
}

