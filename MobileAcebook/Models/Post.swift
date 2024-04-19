//
//  Post.swift
//  MobileAcebook
//
//  Created by LIZZY PEDLEY on 16/04/2024.
//

import Foundation

public struct Post: Codable {
    var _id: String
    var message: String
    var createdAt: String
    var imgUrl: String?
    var createdBy: CreatedBy
    var likes: [String]
}

public struct CreatedBy: Codable {
    var _id: String
    var username: String
    var profilePicture: String
}

public struct Likes: Codable {
    var _id: String
    var message: String
    var createdAt: String
    var createdBy: String
    var imgUrl: String?
    var likes: [String]
}
