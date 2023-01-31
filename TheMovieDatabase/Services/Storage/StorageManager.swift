//
//  StorageManager.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 31.01.2023.
//

import Foundation
import RealmSwift

class StorageManager {
    private let realm = try! Realm()
    
    func saveAccountDetails(_ user: User) {
        do {
            try realm.write({
                let object = AccountDetailsRealm()
                
                object.id = user.id!
                object.name = user.name!
                object.username = user.username!
                object.avatarPath = (user.avatar?.gravatar?.hash)!
                
                realm.add(object, update: .modified)
            })
        } catch {
            print("Error account details saving: \(error.localizedDescription)")
        }
    }
}

