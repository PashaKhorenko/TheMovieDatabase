//
//  SessionID.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 19.01.2023.
//

import Foundation

struct SessionID: Decodable {
    let sessionID: String?
    
    enum CodingKeys: String, CodingKey {
        case sessionID = "session_id"
    }
}
