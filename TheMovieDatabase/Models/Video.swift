//
//  Video.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 26.01.2023.
//

import Foundation

// MARK: - Video
struct Video: Codable {
    let results: [Result]?
}

// MARK: - Result
struct Result: Codable {
    let site: String?
    let key: String?
}
