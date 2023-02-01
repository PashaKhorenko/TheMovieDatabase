//
//  SessionIDRealm.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 01.02.2023.
//

import Foundation
import RealmSwift

class SessionIDRealm: Object {
    @Persisted(primaryKey: true) dynamic var id: String = ""
}
