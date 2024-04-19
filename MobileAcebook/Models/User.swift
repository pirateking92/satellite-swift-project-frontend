//
//  User.swift
//  MobileAcebook
//
//  Created by Josué Estévez Fernández on 01/10/2023.
//

public struct User: Codable {
    var username: String
    var password: String
    var email: String
}

public struct UserData: Codable {
    var _id: String
    var email: String
    var password: String
    var username: String
    var imgUrl: String
    var __v: Int
}
