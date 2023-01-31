//
//  AccountDetailsRealm.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 31.01.2023.
//

import Foundation
import RealmSwift

class AccountDetailsRealm: Object {
    @Persisted(primaryKey: true) dynamic var id: Int = 0
    @Persisted dynamic var name: String = ""
    @Persisted dynamic var username: String = ""
    @Persisted dynamic var avatarPath: String = ""

}
