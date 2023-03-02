//
//  Video.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 26.01.2023.
//

import Foundation

// MARK: - Video
struct Videos: Decodable {
    let results: [Video]?
}

// MARK: - Video
struct Video: Decodable {
    let official: Bool?
    let site: String?
    let key: String?
}
