//
//  StorageProtocol.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.02.2023.
//

import Foundation

protocol StorageProtocol {
    // MARK: Saving
    func saveSessionIDToStorage(_ id: String)
    func saveAccountDetailsToStorage(_ user: User)
    func savePreviousSearchesToStorage(_ searchText: String)
    func saveSessionType(_ sessionType: SessionType)
    
    // MARK: Getting
    func getAccountDetailsFromStorage() -> AccountDetailsRealm?
    func getAccountIDFromStorage() -> Int
    func getSessionIDFromStorage() -> String
    func getPreviousSearchesFromStorage() -> [String]
    func getSessionType() -> SessionType?
    
    // MARK: Deleting
    func deleteAccountDetailsAndSessionId()
    func deletePreviousSearchByIndex(_ index: Int)
    func deleteSessionTypeFromStorage()
}
