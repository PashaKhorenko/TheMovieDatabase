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
    
    func saveSessionID(_ id: String) {
        do {
            try realm.write({
                let object = SessionIDRealm()
                
                object.id = id
                
                realm.add(object)
            })
        } catch {
            print("Error sessionID saving: \(error.localizedDescription)")
        }
    }
    
    func saveAccountDetails(_ user: User) {
        do {
            try realm.write({
                let object = AccountDetailsRealm()
                
                object.id = user.id!
                object.name = user.name!
                object.username = user.username!
                object.avatarPath = (user.avatar?.gravatar?.hash)!
                
                realm.add(object)
            })
        } catch {
            print("Error account details saving: \(error.localizedDescription)")
        }
    }
}

