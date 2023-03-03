//
//  SignUpViewModelProtocol.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 03.03.2023.
//

import Foundation

protocol SignUpViewModelProtocol {
    
    var networkManager: SignUpNetworkManagerProtocol? { get }
    var storageManager: StorageProtocol? { get }

    var guestSessionID: Dynamic<String?> { get set }
    
    func featchGuestSessionID()
    func saveGuestSessionID()
    func logInToGuestSession()
    
}
