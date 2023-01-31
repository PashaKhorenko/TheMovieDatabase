//
//  SessionID.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 19.01.2023.
//

import Foundation

struct SessionID: Codable {
    let success: Bool
    let sessionID: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case sessionID = "session_id"
    }
}
