//
//  SignUpNetworkManagerProtocol.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 03.03.2023.
//

import Foundation

protocol SignUpNetworkManagerProtocol {
    func decoder() -> JSONDecoder
    func createGuestSessionID(_ completion: @escaping (String) -> Void)
}
