//
//  TestAPI.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 19.01.2023.
//

import Foundation

struct RequestToken: Codable {
    let success: Bool
    let expiresAt, requestToken: String

    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}
