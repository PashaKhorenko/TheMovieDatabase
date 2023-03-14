//
//  SettingsNetworkManagerProtocol.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 14.03.2023.
//

import Foundation

protocol SettingsNetworkManagerProtocol {
    func decoder() -> JSONDecoder
    func deleteCurrent(sessiondID: String, _ completion: @escaping (Bool) -> Void)
}
