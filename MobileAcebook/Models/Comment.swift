//
//  Comment.swift
//  MobileAcebook
//
//  Created by Matt Doyle on 19/04/2024.
//

import Foundation

public struct Comment: Codable {
    var _id: String
    var message: String
    var createdAt: String
    var createdBy: CommentsCreatedBy
}

public struct CommentsCreatedBy: Codable {
    var _id: String
    var username: String
}

