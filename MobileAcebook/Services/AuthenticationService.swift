//
//  AuthenticationService.swift
//  MobileAcebook
//
//  Created by Josué Estévez Fernández on 01/10/2023.
//

import Foundation

struct LoginResponse: Codable {
    let message: String
    let token: String
}

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
    

    
    func login(user: User, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:3000/tokens") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
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
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "HTTP Error", code: (response as? HTTPURLResponse)?.statusCode ?? 0, userInfo: nil)))
                return
            }
            
            if let responseData = data {
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: responseData)
                    completion(.success(loginResponse))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
            }
        }.resume()
    }
}




