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
    private let userDefaults = UserDefaults.standard
    
    private let UDSessionTypeKey = "sessionType"
    
    // MARK: - Actions with session id
    // Saving
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
    
    // Getting
    func getSessionIDFromStorage() -> String {
        let object = realm.objects(SessionIDRealm.self)
        guard let sessionID = object.first?.id else { return "" }
        return sessionID
    }
    
    // MARK: - Actions with accounts details
    // Saving
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
    
    // Getting
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
    
    // MARK: - Delete AccountDetails And SessionId
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
    
    // MARK: - Actions with previous searches
    // Saving
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
    
    // Getting
    func getPreviousSearchesFromStorage() -> [String] {
        let objects = realm.objects(PreviousSearchesRealm.self)

        var previousSearchesArray: [String] = []
        
        for object in objects {
            previousSearchesArray.append(object.previousSearch)
        }
        
        return previousSearchesArray.reversed()
    }
    
    // Deleting
    func deletePreviousSearchByIndex(_ index: Int) {
        do {
            try realm.write() {
                let objects = realm.objects(PreviousSearchesRealm.self)
                let objectToDelete = objects[index]
                
                realm.delete(objectToDelete)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Actions with session type
    // Saving
    func saveSessionType(_ sessionType: SessionType) {
        userDefaults.set(sessionType.rawValue, forKey: UDSessionTypeKey)
        userDefaults.synchronize()
    }
    
    // Getting
    func getSessionType() -> SessionType? {
        let sessionTypeRawValue = userDefaults.string(forKey: UDSessionTypeKey)
        let sessionType = SessionType(rawValue: sessionTypeRawValue ?? "")
        return sessionType
    }
    
    // Deleting
    func deleteSessionTypeFromStorage() {
        userDefaults.removeObject(forKey: UDSessionTypeKey)
        userDefaults.synchronize()
    }
}
