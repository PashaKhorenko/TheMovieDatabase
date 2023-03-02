//
//  AccountDetails.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 31.01.2023.
//

import Foundation

// MARK: - User
struct User: Decodable {
    let avatar: Avatar?
    let id: Int?
    let name, username: String?
}

// MARK: - Avatar
struct Avatar: Decodable {
    let gravatar: Gravatar?
}

// MARK: - Gravatar
struct Gravatar: Decodable {
    let hash: String?
}
