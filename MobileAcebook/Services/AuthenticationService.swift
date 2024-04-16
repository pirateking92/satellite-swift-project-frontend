//
//  AuthenticationService.swift
//  MobileAcebook
//
//  Created by Josué Estévez Fernández on 01/10/2023.
//

import Foundation


class AuthenticationService: AuthenticationServiceProtocol {
    @Published var isSignedUp = false
    @Published var signUpError: Error?
    
    //User sign-up function, taking as parameters an instance of User and a completion handler (used to signal that a Network Request has completed, successfully or unsuccessflly)
    func signUp(user: User) -> Bool {
        guard let url = URL(string: "http://localhost:3000/users") else {
            return false
        }
//        
//        func signUp(user: User, completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
//            guard let url = URL(string: "http://localhost:3000/users") else {
//                completion(false, error)
//            }
        
        //Try to make a URL object from the given string. If that fails (eg. because it's not formatted properly),  set isSignedUp to false and leave function.
    
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //Set up a URL request, matching the URL I gave you above. And set the http method to post, meaning we're sending data to the server.
        
        let userData: [String: Any] = [
            "email": user.email,
            "username": user.username,
            "password": user.password
        ]
        
        //This is what this user's user data and the data's attributes/types are. It's current form is a Swift dictionary.
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userData, options: [])
            request.httpBody = jsonData
        } catch {
//            completion(false, error)
            return false
        }
        
        // Convert that Swift dictionary into JSON so that it can be used as the body of our http POST request. If you encounter issues, keep the isSignedUp value as false and leave the function at this point.
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data, error == nil else {
                self.signUpError = error
                return
            }
            
            // Start a data task (ie. the uploading of the user's data). If there is an error while doing this, assign the error to our optional signUpError variable so that the nature of the error is captured.
            
        }.resume()
//        completion(true, nil)
        return true
        //Provided there have been no errors so far, set the isSignedUp value to true.
    }
}
//Questions:
//1) Because the function is set up asynchronously, the isSignedUp value will be set to true before the checks have finished running, meaning it doesn't work as intended.
//Asynchronous is best practice, so how do we achieve both asynchronicity and waiting until the checks have run before setting the Boolean value to true.
//Completion handlers?
//2) Where do we add our validity checks (eg. is the user already registered, is the password the right strength?), do these go in this file because they're part of the logic, or are they in the View because they result in error messages sent to the user?
