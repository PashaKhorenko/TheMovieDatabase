//
//  PreviousSearchesRealm.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 07.03.2023.
//

import Foundation
import RealmSwift

class PreviousSearchesRealm: Object {
    @Persisted(primaryKey: true) dynamic var previousSearch: String = ""
}
