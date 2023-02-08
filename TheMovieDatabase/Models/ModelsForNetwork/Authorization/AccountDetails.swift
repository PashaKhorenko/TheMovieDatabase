//
//  AccountDetails.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 31.01.2023.
//

import Foundation

// MARK: - User
struct User: Codable {
    let avatar: Avatar?
    let id: Int?
    let name, username: String?
}

// MARK: - Avatar
struct Avatar: Codable {
    let gravatar: Gravatar?
}

// MARK: - Gravatar
struct Gravatar: Codable {
    let hash: String?
}
