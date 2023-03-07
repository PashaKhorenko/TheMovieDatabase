//
//  StorageProtocol.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.02.2023.
//

import Foundation

protocol StorageProtocol {
    func saveSessionIDToStorage(_ id: String)
    func saveAccountDetailsToStorage(_ user: User)
    func savePreviousSearchesToStorage(_ searchText: String)
    func getAccountDetailsFromStorage() -> AccountDetailsRealm?
    func getAccountIDFromStorage() -> Int
    func getSessionIDFromStorage() -> String
    func getPreviousSearchesFromStorage() -> [String]
    func deleteAccountDetailsAndSessionId()
}
