//
//  SettingsViewModelProtocol.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.02.2023.
//

import Foundation

protocol SettingsViewModelProtocol {
    var storageManeger: StorageProtocol? { get }
    
    func getAccountDetails() -> AccountDetailsRealm?
    func signOutOfTheAccount()
}
