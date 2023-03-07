//
//  StorageManager.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 31.01.2023.
//

import Foundation
import RealmSwift

class StorageManager: StorageProtocol {
    private let realm = try! Realm()
    
    func saveSessionIDToStorage(_ id: String) {
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
    
    func saveAccountDetailsToStorage(_ user: User) {
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
    
    func savePreviousSearchesToStorage(_ searchText: String) {
        do {
            try realm.write {
                let object = PreviousSearchesRealm()
                
                object.previousSearch = searchText
                
                realm.add(object, update: .modified)
            }
        } catch {
            print("Error previous searches saving: \(error.localizedDescription)")
        }
    }
    
    func getAccountDetailsFromStorage() -> AccountDetailsRealm? {
        let object = realm.objects(AccountDetailsRealm.self)
        let accountDetails = object.first
        return accountDetails
    }
    
    func getAccountIDFromStorage() -> Int {
        guard let accountDetails = self.getAccountDetailsFromStorage() else { return 0 }
        let accountID = accountDetails.id
        return accountID
    }
    
    func getSessionIDFromStorage() -> String {
        let object = realm.objects(SessionIDRealm.self)
        guard let sessionID = object.first?.id else { return "" }
        return sessionID
    }
    
    func getPreviousSearchesFromStorage() -> [String] {
        let objects = realm.objects(PreviousSearchesRealm.self)

        var previousSearchesArray: [String] = []
        
        for object in objects {
            previousSearchesArray.append(object.previousSearch)
        }
        
        return previousSearchesArray.reversed()
    }
    
    func deleteAccountDetailsAndSessionId() {
        do {
            try realm.write() {
                let accountDetailsObject = realm.objects(AccountDetailsRealm.self)
                let sessionIdObject = realm.objects(SessionIDRealm.self)
                
                realm.delete(accountDetailsObject)
                realm.delete(sessionIdObject)
                
                print("Delete accountDetails and session Id from Realm storage")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

